require! {
    \express
    \nocache
    \body-parser
    \serve-static
    \blockstarter-wl
    \hashcash-token
    \ddos
    \./package.json : pack
    \prelude-ls : { map }
    \./contract-api.js
}
{ getFrontendData } = contract-api
{ config } = pack

app = express!
app.use nocache!

__path = __dirname + \/public

if config.performance.keep-static-in-memory
  app.use(serve-static(__path, { max-age: \0 }))
else
  app.use express.static( __path )

if config.performance.use-ddos-protection
  protection = new ddos config.request-limits
  app.use protection.express

console.log "init route /"
app.get \/ , (req, res)->
    res.redirect \/login/index.html

app.use body-parser.json!

transform = (key, data, cb)->
  #console.log data
  switch key 
     case \panel 
        getFrontendData data, cb 
     else 
       cb null, data
        
create-route = (key)->
    console.log "init route /api/#{key}"
    req, resp <-! app.post "/api/#{key}"
    
    ip = req.headers[\x-forwarded-for] ? req.connection.remote-address.replace('::ffff:', '')
    if config.performance.require-request-payment
      requestpayment = req.headers.requestpayment
      return resp.status(403).end! if not requestpayment?
      [nonce_str, hash, rarity_str] = requestpayment.split('|')
      nonce = parse-int nonce_str
      rarity = parse-float rarity_str
      difficulty = 1000
      data = "#ip/#key"
      #valid =
      #   hashcash-token.validate({ nonce, hash, rarity, data , difficulty } )
      #return resp.status(401).end! if not valid 
    
    request = {} <<<< req.body <<<< config
    request.ip = ip
    delete request.dashboard
    delete request.performance
    err, data <-! blockstarter-wl[key] request
    return resp.status(400).send(err.response?text) if err?
    err, transformed <-! transform key, data
    return resp.status(500).send(err) if err?
    resp.send transformed

blockstarter-wl |> Object.keys |> map create-route

module.exports = app