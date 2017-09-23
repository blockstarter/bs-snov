require! {
    \express
    \body-parser
    \serve-static
    \blockstarter-wl
    \ddos
    \./config.json
    \prelude-ls : { map }
}

app = express!
app.use body-parser.json!

__path = __dirname + \/public

if config.server.use-static
  app.use(serve-static(__path, { max-age: \1y }))
else
  app.use express.static( __path )

do 
  protection = new ddos config.request-limits
  app.use protection.express

console.log "init route /"
app.get \/ , (req, res)->
    
    res.redirect \/login/index.html


create-route = (key)->
    console.log "init route /api/#{key}"
    req, resp <-! app.post "/api/#{key}"
    request = {} <<<< req.body <<<< config
    err, data <-! blockstarter-wl[key] request
    console.log "response #{key} -> err: #{err}"
    #console.log err, data
    return resp.status(400).send(err.response?text) if err?
    resp.send data

blockstarter-wl |> Object.keys |> map create-route

app.listen config.server.port