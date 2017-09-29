angular
    .module \app, [\ngStorage, \pascalprecht.translate, \members , \proofofwork ]
    .config ($translate-provider) ->
        $translate-provider.translations \en , 
            "Copyright © Snov.io 2017" : "Copyright © Snov.io 2017" 
            "Tokens you hold" : "Tokens you hold" 
            "You contributed" : "You contributed" 
            "First week" : "First week" 
            "First day" : "First day" 
            "Bonuses:" : "Bonuses:" 
            "Snov token price:" : "Snov token price:" 
            "Token crowdsale pool:" : "Token crowdsale pool:" 
            "Confirm" : "Confirm" 
            "Enter your ETH wallet number" : "Enter your ETH wallet number" 
            "If you are purchasing SNOV Tokens with any currency other than BTC, please note that price of SNOV Tokens would be calculated at the time of actual purchase of the SNOV Tokens and not at the time of transfer of the funds to your account wallets." : "If you are purchasing SNOV Tokens with any currency other than BTC, please note that price of SNOV Tokens would be calculated at the time of actual purchase of the SNOV Tokens and not at the time of transfer of the funds to your account wallets."  
            "Please note that transfer of funds to your account wallets does not constitute a purchase of the SNOV Tokens. After the funds are deposited, you would need to complete Step 3 to purchase the required number of SNOV tokens with the deposited funds." : "Please note that transfer of funds to your account wallets does not constitute a purchase of the SNOV Tokens. After the funds are deposited, you would need to complete Step 3 to purchase the required number of SNOV tokens with the deposited funds."  
            "The calculator is provided for your convenience. You can enter a number of SNOV Tokens you wish to buy and calculate the amount you would need to have in your account wallets." : "The calculator is provided for your convenience. You can enter a number of SNOV Tokens you wish to buy and calculate the amount you would need to have in your account wallets."  
            "You are able to buy SNOV Tokens using BTC, ETH, LTC, DASH, ZEC, ETC, or USD (wire transfer for any amount over $1,000)." : "You are able to buy SNOV Tokens using BTC, ETH, LTC, DASH, ZEC, ETC, or USD (wire transfer for any amount over $1,000)." 
            "User Settings" : "User Settings"  
            "See All Alerts" : "See All Alerts" 
            "Film festivals used to be do-or-die moments for movie makers. They were where..." : "Film festivals used to be do-or-die moments for movie makers. They were where..." 
            "3 mins ago" : "3 mins ago" 
            "John Smith" : "John Smith" 
            "Log Out" : "Log Out" 
            "Settings" : "Settings" 
            "Profile" : "Profile" 
            "Ru" : "Ru" 
            "En" : "En" 
            "confirm your email" : "confirm your email" 
            "Thank you for registration. Please" : "Thank you for registration. Please"  
            "ICO snovio dashboard " : "ICO snovio dashboard "
        $translate-provider.translations \ru ,
            "Copyright © Snov.io 2017" : "Copyright © Snov.io 2017" 
            "Tokens you hold" : "Ваши токены" 
            "You contributed" : "Внесено" 
            "First week" : "Первая неделя"
            "First day" : "Первый день" 
            "Bonuses:" : "Бонусы:" 
            "Snov token price:" : "Стоимость токена Snov:" 
            "Token crowdsale pool:" : "Пул предпродажи токенов:"
            "Confirm" : "Подтвердить" 
            "Enter your ETH wallet number" : "Введите номер ETH кошелька" 
            "If you are purchasing SNOV Tokens with any currency other than BTC, please note that price of SNOV Tokens would be calculated at the time of actual purchase of the SNOV Tokens and not at the time of transfer of the funds to your account wallets." : "Если вы покупаете токены SNOV с любой валютой, отличной от BTC, обратите внимание, что цена токенов SNOV будет рассчитываться во время фактической покупки токенов SNOV, а не при передаче денежных средств на ваши кошельки."  
            "Please note that transfer of funds to your account wallets does not constitute a purchase of the SNOV Tokens. After the funds are deposited, you would need to complete Step 3 to purchase the required number of SNOV tokens with the deposited funds." : "Пожалуйста, обратите внимание, что перевод денежных средств на кошельки с вашего счета не является покупкой токенов SNOV. После того, как средства будут депонированы, вам нужно будет завершить Шаг 3, чтобы приобрести необходимое количество токенов SNOV с депонированными средствами."  
            "The calculator is provided for your convenience. You can enter a number of SNOV Tokens you wish to buy and calculate the amount you would need to have in your account wallets." : "Калькулятор предоставляется для вашего удобства. Вы можете ввести несколько токенов SNOV, которые хотите купить, и рассчитать сумму, которую вы должны будете иметь в кошельках с учетной записью."  
            "You are able to buy SNOV Tokens using BTC, ETH, LTC, DASH, ZEC, ETC, or USD (wire transfer for any amount over $1,000)." : "Вы можете купить токены SNOV с использованием BTC, ETH, LTC, DASH, ZEC, ETC или USD (банковский перевод на любую сумму более 1000 долларов США)." 
            "User Settings" : "Пользовательские настройки"  
            "See All Alerts" : "Просмотреть все предупреждения" 
            "Film festivals used to be do-or-die moments for movie makers. They were where..." : "Кинофестивали раньше были для кинорежиссеров, и они были там ..." 
            "3 mins ago" : "3 минуты назад" 
            "John Smith" : "Джон Смит" 
            "Log Out" : "Выход" 
            "Settings" : "Настройки" 
            "Profile" : "Профиль" 
            "Ru" : "Рус" 
            "En" : "Анг" 
            "confirm your email" : "подтвердите ваш адрес электронной почты" 
            "Thank you for registration. Please" : "Спасибо, что зарегистрировались. Пожалуйста"  
            "ICO snovio dashboard " : "snovio ICO панель управления"
        $translate-provider.preferred-language \en
    .run (proofofwork)->
        proofofwork.make \updateProfile
    .controller \settings, ($scope, $http, $local-storage)->
        export form =
            address: ""
            
        {profile} = $localStorage.dashboard.user
        form.address = profile.address if profile.type == 'eth'
        
        export confirm = ->
            return swal "Please try again in 2 seconds" if not $http.defaults.headers.common.request-payment?
            return swal "Please enter a valid Ethereum address" if not web3.isAddress form.address
            $http
              .post \/api/updateProfile, { form.address, ...$local-storage }
              .then ->
                  swal "Done"
              .catch (resp)->
                  swal resp.data
                  
        $scope <<<< out$