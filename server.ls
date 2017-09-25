require! {
  \./app.js
  \./package.json : pack
}

{ config } = pack

app.listen config.server.port