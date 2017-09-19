angular
    .module \app, [\flyber, \ngStorage, \pascalprecht.translate ]
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
            "Please make sure your deposit equals or exceeds the minimum purchase amount (at the current exchange rate it is 0.012 BTC)" : "Пожалуйста, убедитесь, что ваш депозит равен или превышает минимальную сумму покупки (при текущем обменном курсе это 0,012 BTC)" 
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
    .controller \members, ($scope, $http, $local-storage, $window)->
        m = 1000000
        create-transaction = ->
          url: "http://google.com.ua"
          date: new Date!
          tx: "2424234234234234234234234234234234"
          address: "0x23423432423443423423423"
          assigned: 0.12
        init = (func)->
            s = init.scripts = init.scripts ? []
            init.all = -> s.for-each(-> it!)
            s.push func
            func
        export set-current = init (rate)->
            model.current-rate = rate ? model.rates.0
            change-price!
        export change-price = ->
            model.you-pay = 
                model.you-buy * model.current-rate.change
        export model =
            loading: yes
            you-buy: 100000
            you-pay: 0.05
            current-rate: {}
            languages: 
                * title: \Ru 
                  name: \ru 
                * title: \En 
                  name: \en
            timer: 
                days: 0
                hours: 0
                minutes: 0
                seconds: 0
            progress: 
                min: 5 * m
                max: 15 * m
                current:
                    usd: 11 * m
                    eth: 18 * m / 300
                    percent: "70%"
                    contributors: 200
                
            token-price-eth: 0.015
            bonuses: 
                first-day: 15
                first-week: 5
            rates: []
            transactions:
                * create-transaction!
                * create-transaction!
                * create-transaction!
                * create-transaction!
            you:
                contributed-eth: 12
                tokens-you-hold: 3
        $window.model = model
        
        transform-rates = (rate)->
            rate.change = rate.rate
            rate
        $http
          .post \/api/panel, $local-storage
          .then (resp)->
             model.loading = no
             model.rates = resp.data.rates.map(transform-rates)
             init.all!
          .catch (resp)->
             location.href = \/login
        export buy = ($event)->
            $event.prevent-default!
            
        export logout = ($event)->
            $event.prevent-default!
            $local-storage.session-id = null
            { location.href } = $event.target
        $scope <<<< out$