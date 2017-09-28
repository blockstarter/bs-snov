angular
  .module \proofofwork, []
  .service \proofofwork, ($http)->
        make: (type, cb)->
            resp <-! $http.get \https://api.ipify.org?format=json .then
            difficulty = 70000
            data = "#{resp.data.ip}/#type"
            res  = hashcash.generate {difficulty, data}
            { nonce, hash, rarity } = res
            #console.log({ nonce, hash, rarity, difficulty, data })
            $http.defaults.headers.common.request-payment = "#nonce|#hash|#rarity"
            cb?!
     