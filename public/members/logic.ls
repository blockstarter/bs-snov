angular
    .module \members, [\flyber, \ngStorage, \pascalprecht.translate ]
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
    .controller \members, ($scope, $http, $local-storage, $window, $translate, $timeout)->
        m = 1000000
        init = (func)->
            s = init.scripts = init.scripts ? []
            init.all = -> s.for-each(-> it!)
            s.push func
            func
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

        export model =
            loading: yes
            address: "Loading..."
            you-buy: 100000
            you-pay: 0.05
            current-rate: {}
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
                first-day: 15
                first-week: 5
            rates: []
            transactions: []
            you:
                contributed-eth: 12
                tokens-you-hold: 3
                email: null
                confirmed: no
        transform-rates = (rate)->
            rate.change = rate.rate
            rate
        export notification-read-complete = (notification)->
            notification.is-read = yes 
            $http
              .post \/api/notificationReadComplete, { notification.id,  ...$local-storage } 
              .then (resp)->
              .catch ->
                  notification.is-read = no
        $http
          .post \/api/panel, $local-storage
          .then (resp)->
             #BS to SNOVIO transformation
             usd = resp.data.rates.filter(-> it.token is \USD).0
             model.loading = no
             model.rates = resp.data.rates.map(transform-rates)
             model.you.email = resp.data.user.profile.email
             model.you.confirmed = resp.data.user.profile.confirmed
             model.you.contributed-eth = resp.data.user.contribution.total
             model.you.tokens-you-hold = resp.data.user.contribution.own
             model.transactions = resp.data.user.transactions
             model.progress.max = resp.data.config.panelinfo.max_cap_in_eth * usd.rate
             model.progress.min = resp.data.config.panelinfo.min_cap_in_eth * usd.rate
             model.progress.current.usd = resp.data.campaign.total
             model.progress.current.eth = resp.data.campaign.total / usd.rate
             model.progress.current.percent = "#{resp.data.campaign.percent}%"
             model.progress.current.contributors = resp.data.campaign.contributions
             model.progress.token-price-eth = 1 / resp.data.campaign.price
             
             init.all!
          .catch (resp)->
             #location.href = \/login
            
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
            { token } = model.current-rate
            model.address = "Loading..."
            $http
              .post \/api/address , { type: token, ...$local-storage } 
              .then (resp)->
                  { model.address } = resp.data 
                  
              .catch ->
                  swal "Oops. Server error :("
        export logout = ($event)->
            $event.prevent-default!
            $local-storage.session-id = "N"
            { location.href } = $event.target
        $scope <<<< out$
        $window.debug = {}
        $window.debug <<<< out$