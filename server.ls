require! {
    \express
    \body-parser
    \serve-static
    \blockstarter-wl
    \hashcash-token
    \ddos
    \./config.json
    \prelude-ls : { map }
}

app = express!


__path = __dirname + \/public

if config.performance.keep-static-in-memory
  app.use(serve-static(__path, { max-age: \1y }))
else
  app.use express.static( __path )

if config.performance.use-ddos-protection
  protection = new ddos config.request-limits
  app.use protection.express

console.log "init route /"
app.get \/ , (req, res)->
    res.redirect \/login/index.html

app.use body-parser.json!


create-route = (key)->
    console.log "init route /api/#{key}"
    req, resp <-! app.post "/api/#{key}"
    
    if config.performance.require-request-payment
      ip = req.headers['x-forwarded-for']
      requestpayment = req.headers.requestpayment
      return resp.status(401).end! if not requestpayment?
      [nonce_str, hash, rarity_str] =requestpayment.split('|')
      nonce = parse-int nonce_str
      rarity = parse-float rarity_str
      difficulty = 70000
      data = "#ip/#key"
      valid =
         hashcash-token.validate({ nonce, hash, rarity, data , difficulty } )
      return resp.status(401).end! if not valid 
    request = {} <<<< req.body <<<< config
    err, data <-! blockstarter-wl[key] request
    console.log "response #{key} -> err: #{err}"
    #console.log err, data
    return resp.status(400).send(err.response?text) if err?
    resp.send data

blockstarter-wl |> Object.keys |> map create-route

app.listen config.server.port