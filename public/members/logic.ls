angular
    .module \members, [\ngStorage, \pascalprecht.translate , \proofofwork, \languages ]
    .filter \remove_sign, ->
        -> it.replace('$', '')
        
    .filter \cut, ($filter)->
        (value)->
            return "" if not value?
            #parse-int value.to-string!
            $filter('currency')(value, '', 0)
            
    .filter \shorten_tx, ->
        -> it.slice(0, 6) + '...' + it.slice(-4)
        
    .directive \qrcode, ->
        restrict: \A
        scope: 
            qrcode: \=
        controller: ($scope, $element)->
            $scope.$watch \qrcode, (value)->
                $element.empty!
                new QRCode($element.0, value)
    .controller \members, ($scope, $http, $local-storage, $root-scope, $window, $translate, $timeout, proofofwork)->
        $scope.loaded = ->
            $scope.model?loading is false
        
        
        m = 1000000
        init = (func)->
            s = init.scripts = init.scripts ? []
            init.all = -> s.for-each(-> it!)
            s.push func
            func
            
        setup = init ->
            # Ensure that default language is selected
            $local-storage.language = 'en' if not $local-storage.language
            { dashboard } = $local-storage
            usd = dashboard.rates.filter(-> it.token is \USD).0
            model.eth-address = dashboard.config.wallet.multisig_eth
            model.rates = dashboard.rates.filter(-> it.disabled is no).map(transform-rates usd)
            model.you.email = dashboard.user.profile.email
            model.you.confirmed = dashboard.user.profile.confirmed
            model.you.valid-address = dashboard.user.profile.address.index-of('0x') is 0
            model.you.contributed-eth = dashboard.user.contribution.total
            model.transactions = dashboard.user.profile.transaction ? []
            model.you.tokens = model.transactions.reduce ((acc, tx) -> acc + tx.assignedTokens), 0
            
            model.progress.min = dashboard.contract.minCapInUsd.toString!
            model.progress.max = dashboard.contract.maxCapInUsd.toString!
            
            model.progress.current.usd = dashboard.contract.totalInUsd
            model.progress.current.eth = dashboard.contract.totalEth
            model.progress.current.percent = dashboard.contract.progressPercent.toString! + "%"
            model.progress.current.contributors = dashboard.contract.totalSales
            model.progress.token-price-eth = 1 / dashboard.campaign.price
            
            $root-scope.user = dashboard.user
            
            model.loading = no
             
        export set-current = init (rate)->
            model.current-rate = rate ? model.rates.0
            change-price!
        export show = {}
        export collapse = {}
        export change-price = ->
            buy = new BigNumber(model.you-buy ? 0)
            bonus =
                | buy.gte(5000000)  => 1.25
                | buy.gte(500000)  => 1.15
                | _ => 1
            model.you-pay = 
                new BigNumber(model.you-buy).mul(model.current-rate.change).div(bonus).round(8)
        update-time = init ->
            update = ([head, ...tail])->
                if model.timer[head] > 0
                   model.timer[head] -= 1
                else if head isnt \days
                   model.timer[head] = 59
                   update tail
            update <[ seconds minutes hours days ]>
            $timeout update-time, 1000
        
        distance = Date.UTC(2017, 9, 31, 12, 0, 0, 0) - new Date!.get-time!
        start = humanizeDuration(distance, { delimiter: ';', units: ['d', 'h', 'm', 's'] }).split(";").map(-> it.split(' '))
        
        time-part = (name)->
           parse-int start.filter(-> it.1 is name).0?0 ? 0
        
        transform-rates = (usd, rate)-->
            rate.change = new BigNumber(rate.rate).div(usd.rate).div(100)
            rate
            
        export model =
            warning: []
            loading: yes
            address: "Loading..."
            you-buy: 500000
            you-pay: 0.05
            current-rate: {}
            eth-address: null
            languages: 
                * title: \Ru 
                  name: \ru 
                * title: \En 
                  name: \en
            timer: 
                days: time-part \days
                hours: time-part \hours
                minutes: time-part \minutes
                seconds: time-part \seconds
            progress: 
                min: 0
                max: 0
                current:
                    usd: 0
                    eth: 0
                    percent: "0%"
                    contributors: 0
            token-price-eth: 0
            bonuses: 
                first-day: 10
                first-week: 5
            rates: []
            transactions: []
            you:
                contributed-eth: 12
                tokens-you-hold: 3
                email: null
                confirmed: no
                
        export notification-read-complete = (notification)->
            notification.is-read = yes 
            $http
              .post \/api/notificationReadComplete, { notification.id,  ...$local-storage } 
              .then (resp)->
              .catch ->
                  notification.is-read = no
        
        export $local-storage
        
        change-language = init (language)->
            $translate.use(language ? $local-storage.language)
            
        export set-language = (language)->
            $local-storage.language = language
            change-language language
            
        export confirm-email-address = ->
            return if not model.you.email?
            "https://" + model.you.email.replace(/^[^@]+@/ig,'')
            
        export buy = ($event) !->
            model.warning = []
            # return swal "Please try again in 2 seconds" if not $http.defaults.headers.common.request-payment?
            { token } = model.current-rate
            model.address = "Loading..."
            if token is \ETH then 
                model.address = model.eth-address
                model.warning =
                    * 'Recommended Fee'
                    * 'Gas Limit: 150000' 
                    * 'Gas Price: 0.000000021 Ether (21 Gwei)'
            else
                
                $http
                  .post \/api/address , { type: token, ...$local-storage } 
                  .then (resp)->
                      model.address = resp.data 
                      
                  .catch ->
                      model.address = "Cannot obtain address :("
                      model.warning =
                        * 'Please ask administrator for help a.stegno@gmail.com'
                        ...
                  
        export logout = ($event)->
            $event.prevent-default!
            $local-storage.session-id = "N"
            $local-storage.dashboard = {}
            #console.log $event.target.href
            
            location.href = $event.target.href

        export isLoggedIn = ->
            $local-storage.session-id && $local-storage.session-id != "N"
            
        goToLoginPage = ->
            location.href = \/login/index.html

        if location.href.indexOf(\members) > -1
            # <-! proofofwork.make \panel
            $http
              .post \/api/panel, { $local-storage.session-id }
              .then (resp)->
                 $local-storage.dashboard = resp.data
                 init.all!
                #  <-! proofofwork.make \address
              .catch (resp)->
                 #console.log resp
                 #if resp.status is 401
                 goToLoginPage!
        else if !isLoggedIn!
            goToLoginPage!
        else
            init.all!

        $scope <<<< out$