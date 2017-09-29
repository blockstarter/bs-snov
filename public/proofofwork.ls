angular
  .module \proofofwork, []
  .service \proofofwork, ($http)->
        state =
          ip: null
        get-ip = (cb)->
            return cb(state.ip) if state.ip?
            delete $http.defaults.headers.common.request-payment
            resp <-! $http.get \https://api.ipify.org?format=json .catch(cb).then
            cb resp.data.ip
        make: (type, cb)->
            ip <-! get-ip!
            difficulty = 1000
            data = "#{ip}/#type"
            res  = hashcash.generate { difficulty, data }
            { nonce, hash, rarity } = res
            $http.defaults.headers.common.request-payment = "#nonce|#hash|#rarity"
            cb?!
     