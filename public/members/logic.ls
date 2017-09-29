angular
    .module \members, [\ngStorage, \pascalprecht.translate , \proofofwork ]
    .filter \remove_sign, ->
        -> it.replace('$', '')
    .config ($translate-provider) ->
        $translate-provider.translations \en , 
            "ICO snovio dashboard" : "ICO snovio dashboard"
            "Thank you for registration. Please" : "Thank you for registration. Please"
            "confirm your email" : "confirm your email"
            "En" : "En"
            "Ru" : "Ru"
            "Profile" : "Profile"
            "Settings" : "Settings"
            "Log Out" : "Log Out" 
            "John Smith" : "John Smith" 
            "3 mins ago" : "3 mins ago" 
            "Film festivals used to be do-or-die moments for movie makers. They were where..." : "Film festivals used to be do-or-die moments for movie makers. They were where..." 
            "See All Alerts" : "See All Alerts" 
            "Crowdsale starts in" : "Crowdsale starts in" 
            "Days" : "Days" 
            "Minutes" : "Minutes" 
            "Seconds" : "Seconds" 
            "Tokensale progress" : "Tokensale progress" 
            "Softcap" : "Softcap" 
            "Tokensale status" : "Tokensale status" 
            "Calculate" : "Calculate" 
            "Your buy" : "Your buy" 
            "Snov tokens" : "Snov tokens" 
            "Your pay" : "Your pay" 
            "Please make sure your deposit equals or exceeds the minimum purchase amount (at the current exchange rate it is 0.012 BTC)" : "Please make sure your deposit equals or exceeds the minimum purchase amount (at the current exchange rate it is 0.012 BTC)" 
            "Your transaction history" : "Your transaction history" 
            "Date" : "Date" 
            "Transaction ID" : "Transaction ID" 
            "Address Source" : "Address Source" 
            "Snov assigned" : "Snov assigned" 
            "Token crowdsale pool:" : "Token crowdsale pool:" 
            "Snov token price:" : "Snov token price:" 
            "Bonuses:" : "Bonuses:" 
            "First day" : "First day" 
            "First week" : "First week" 
            "You contributed" : "You contributed" 
            "Tokens you hold" : "Tokens you hold" 
            "Buy now" : "Buy now" 
            "Copyright © Snov.io 2017" : "Copyright © Snov.io 2017"
        $translate-provider.translations \ru ,
            "ICO snovio dashboard" : "snovio ICO панель управления"
            "Thank you for registration. Please" : "Спасибо, что зарегистрировались. Пожалуйста" 
            "confirm your email" : "подтвердите ваш адрес электронной почты"
            "Ru" : "Рус" 
            "En" : "Анг"
            "Log Out" : "Выход" 
            "Settings" : "Настройки" 
            "Profile" : "Профиль" 
            "Film festivals used to be do-or-die moments for movie makers. They were where..." : "Кинофестивали раньше были для кинорежиссеров, и они были там ..." 
            "3 mins ago" : "3 минуты назад" 
            "John Smith" : "Джон Смит"
            "See All Alerts" : "Просмотреть все предупреждения" 
            "Crowdsale starts in" : "Начало предпродажи начнется через" 
            "Days" : "Дней" 
            "Minutes" : "Минут" 
            "Seconds" : "Секунд" 
            "Tokensale progress" : "Прогресс продажи токенов" 
            "Softcap" : "Softcap" 
            "Tokensale status" : "Статус продажи токенов" 
            "Calculate" : "Калькулятор" 
            "Your buy" : "Вы покупаете" 
            "Snov tokens" : "Snov токены"
            "Your pay" : "Вы платите" 
            "Please make sure your deposit equals or exceeds the minimum purchase amount (please check the minimum amount in WP)" : "Пожалуйста, убедитесь, что ваш депозит равен или превышает минимальную сумму покупки (посмотрите минимальный курс в ВП)" 
            "Snov assigned" : "количество Snov" 
            "Address Source" : "Источник адреса" 
            "Transaction ID" : "Номер транзакции" 
            "Date" : "Дата" 
            "Your transaction history" : "История транзакций"  
            "Buy now" : "Купить сейчас" 
            "Tokens you hold" : "Ваши токены" 
            "You contributed" : "Внесено" 
            "First week" : "Первая неделя"
            "First day" : "Первый день" 
            "Bonuses:" : "Бонусы:" 
            "Snov token price:" : "Стоимость токена Snov:" 
            "Token crowdsale pool:" : "Пул предпродажи токенов:"
            "Copyright © Snov.io 2017" : "Copyright © Snov.io 2017"
        $translate-provider.preferred-language \en
    .directive \qrcode, ->
        restrict: \A
        scope: 
            qrcode: \=
        controller: ($scope, $element)->
            $scope.$watch \qrcode, (value)->
                $element.empty!
                new QRCode($element.0, value)
    .controller \members, ($scope, $http, $local-storage, $window, $translate, $timeout, proofofwork)->
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
            model.eth-address = dashboard.config.wallet.multisig_eth
            usd = dashboard.rates.filter(-> it.token is \USD).0
            model.rates = dashboard.rates.filter(-> it.disabled is no).map(transform-rates dashboard)
            model.you.email = dashboard.user.profile.email
            model.you.confirmed = dashboard.user.profile.confirmed
            
            model.you.contributed-eth = dashboard.user.contribution.total
            model.you.tokens = dashboard.contract.userTokens
            model.you.ethAddress = dashboard.user.profile.address if dashboard.user.profile.type == 'eth'
            model.transactions = dashboard.user.transactions
            
            model.progress.min = dashboard.contract.minCapInUsd.toString!
            model.progress.max = dashboard.contract.maxCapInUsd.toString!
            
            model.progress.current.usd = dashboard.contract.totalInUsd.toString!
            model.progress.current.eth = dashboard.contract.totalEth.toString!
            model.progress.current.percent = dashboard.contract.progressPercent.toString! + "%"
            model.progress.current.contributors = dashboard.contract.totalSales
            model.progress.token-price-eth = 1 / dashboard.campaign.price
            
            model.loading = no
             
        export set-current = init (rate)->
            model.current-rate = rate ? model.rates.0
            change-price!
        export show = {}
        export change-price = ->
            model.you-pay = 
                model.you-buy * model.current-rate.change
        update-time = init ->
            update = ([head, ...tail])->
                if model.timer[head] > 0
                   model.timer[head] -= 1
                else if head isnt \days
                   model.timer[head] = 59
                   update tail
            update <[ seconds minutes hours days ]>
            $timeout update-time, 1000
        
        distance = new Date(2017, 9, 3, 0, 0, 0, 0).get-time! - new Date!.get-time!
        start = humanizeDuration(distance, { delimiter: ';', units: ['d', 'h', 'm', 's'] }).split(";").map(-> it.split(' '))
        
        time-part = (name)->
           parse-int start.filter(-> it.1 is name).0?0 ? 0
        
        transform-rates = (all, rate)-->
            { tokens_per_eth } = all.config.panelinfo
            console.log { tokens_per_eth }, rate.rate
            rate.change = 1 / rate.rate * tokens_per_eth
            rate
            
        export model =
            loading: yes
            address: "Loading..."
            you-buy: 100000
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
            return swal "Please try again in 2 seconds" if not $http.defaults.headers.common.request-payment?
            { token } = model.current-rate
            model.address = "Loading..."
            if token is \ETH then 
                model.address = model.eth-address
            else
                
                $http
                  .post \/api/address , { type: token, ...$local-storage } 
                  .then (resp)->
                      model.address = resp.data 
                      
                  .catch ->
                      swal "Oops. Server error :("
                  
        export logout = ($event)->
            $event.prevent-default!
            $local-storage.session-id = "N"
            { location.href } = $event.target

        export isLoggedIn = ->
            $local-storage.session-id && $local-storage.session-id != "N"
            
        goToLoginPage = ->
            location.href = \/login/index.html

        if location.href.indexOf(\members) > -1
            <-! proofofwork.make \panel
            $http
              .post \/api/panel, { $local-storage.session-id }
              .then (resp)->
                 $local-storage.dashboard = resp.data
                 init.all!
                 <-! proofofwork.make \address
              .catch (resp)->
                 if resp.status is 401
                  goToLoginPage!
        else if !isLoggedIn!
            goToLoginPage!
        else
            init.all!

        $scope <<<< out$