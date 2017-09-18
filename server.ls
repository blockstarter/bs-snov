require! {
    \express
    \blockstarter-wl
    \ddos
    \./config.json
}

protection = new ddos { burst: 10, limit: 15 }

app = express!

app.use express.static( __dirname + \/public )

app.use protection.express


bind-wl = (api, req, res)-->
    request = {} <<<< req.body <<<< config
    err, data <-! api request
    return resp.status(400).send(err) if err?
    resp.send data

app.post \auth, bind-wl(blockstarter-wl.auth)

app.post \forgot-password, bind-wl(blockstarter-wl.forgot-password)

app.post \reset-password, bind-wl(blockstarter-wl.reset-password)

app.post \change-password, bind-wl(blockstarter-wl.change-password)

app.get \panel, bind-wl(blockstarter-wl.panel)

app.get \address, bind-wl(blockstarter-wl.address)

app.listen 8080