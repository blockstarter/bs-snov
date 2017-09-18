// Generated by LiveScript 1.5.0
(function(){
  var express, blockstarterWl, ddos, config, protection, app, bindWl;
  express = require('express');
  blockstarterWl = require('blockstarter-wl');
  ddos = require('ddos');
  config = require('./config.json');
  protection = new ddos({
    burst: 10,
    limit: 15
  });
  app = express();
  app.use(express['static'](__dirname + '/public'));
  app.use(protection.express);
  bindWl = curry$(function(api, req, res){
    var request;
    request = importAll$(importAll$({}, req.body), config);
    return api(request, function(err, data){
      if (err != null) {
        return resp.status(400).send(err);
      }
      resp.send(data);
    });
  });
  app.post('auth', bindWl(blockstarterWl.auth));
  app.post('forgot-password', bindWl(blockstarterWl.forgotPassword));
  app.post('reset-password', bindWl(blockstarterWl.resetPassword));
  app.post('change-password', bindWl(blockstarterWl.changePassword));
  app.get('panel', bindWl(blockstarterWl.panel));
  app.get('address', bindWl(blockstarterWl.address));
  app.listen(8080);
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
  function curry$(f, bound){
    var context,
    _curry = function(args) {
      return f.length > 1 ? function(){
        var params = args ? args.concat() : [];
        context = bound ? context || this : this;
        return params.push.apply(params, arguments) <
            f.length && arguments.length ?
          _curry.call(context, params) : f.apply(context, params);
      } : f;
    };
    return _curry();
  }
}).call(this);
