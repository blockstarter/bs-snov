// Generated by LiveScript 1.5.0
(function(){
  var express, bodyParser, serveStatic, blockstarterWl, hashcashToken, ddos, config, map, app, __path, protection, createRoute;
  express = require('express');
  bodyParser = require('body-parser');
  serveStatic = require('serve-static');
  blockstarterWl = require('blockstarter-wl');
  hashcashToken = require('hashcash-token');
  ddos = require('ddos');
  config = require('./config.json');
  map = require('prelude-ls').map;
  app = express();
  __path = __dirname + '/public';
  if (config.performance.keepStaticInMemory) {
    app.use(serveStatic(__path, {
      maxAge: '1y'
    }));
  } else {
    app.use(express['static'](__path));
  }
  if (config.performance.useDdosProtection) {
    protection = new ddos(config.requestLimits);
    app.use(protection.express);
  }
  console.log("init route /");
  app.get('/', function(req, res){
    return res.redirect('/login/index.html');
  });
  app.use(bodyParser.json());
  createRoute = function(key){
    console.log("init route /api/" + key);
    return app.post("/api/" + key, function(req, resp){
      var ip, requestpayment, ref$, nonce_str, hash, rarity_str, nonce, rarity, difficulty, data, valid, request;
      if (config.performance.requireRequestPayment) {
        ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
        requestpayment = req.headers.requestpayment;
        if (requestpayment == null) {
          return resp.status(401).end();
        }
        ref$ = requestpayment.split('|'), nonce_str = ref$[0], hash = ref$[1], rarity_str = ref$[2];
        nonce = parseInt(nonce_str);
        rarity = parseFloat(rarity_str);
        difficulty = 70000;
        data = ip + "/" + key;
        valid = hashcashToken.validate({
          nonce: nonce,
          hash: hash,
          rarity: rarity,
          data: data,
          difficulty: difficulty
        });
        if (!valid) {
          return resp.status(401).end();
        }
      }
      request = importAll$(importAll$({}, req.body), config);
      blockstarterWl[key](request, function(err, data){
        var ref$;
        console.log("response " + key + " -> err: " + err);
        if (err != null) {
          return resp.status(400).send((ref$ = err.response) != null ? ref$.text : void 8);
        }
        resp.send(data);
      });
    });
  };
  map(createRoute)(
  Object.keys(
  blockstarterWl));
  app.listen(config.server.port);
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
}).call(this);
