angular
    .module \app, [\flyber, \ngStorage, \pascalprecht.translate , \members , \proofofwork ]
    .config ($translate-provider) ->
        $translate-provider.translations \en , 
            "ICO snovio dashboard" : "ICO snovio dashboard"  
            "Thank you for registration. Please" : "Thank you for registration. Please" 
            "confirm your email" : "confirm your email" 
            "Copyright © Snov.io 2017" : "Copyright © Snov.io 2017" 
            "Buy now" : "Buy now" 
            "Tokens you hold" : "Tokens you hold" 
            "You contributed" : "You contributed" 
            "First week" : "First week" 
            "First day" : "First day" 
            "Bonuses:" : "Bonuses:" 
            "Snov token price:" : "Snov token price:" 
            "Token crowdsale pool:" : "Token crowdsale pool:" 
            "Snov assigned" : "Snov assigned" 
            "Address Source" : "Address Source" 
            "Transaction ID" : "Transaction ID" 
            "Date" : "Date" 
            "Your transaction history" : "Your transaction history" 
            "Save changes" : "Save changes" 
            "Confirm password" : "Confirm password" 
            "New password" : "New password" 
            "Current password" : "Current password" 
            "Email" : "Email" 
            "Username" : "Username" 
            "User Profile" : "User Profile" 
            "See All Alerts" : "See All Alerts" 
            "Film festivals used to be do-or-die moments for movie makers. They were where..." : "Film festivals used to be do-or-die moments for movie makers. They were where..." 
            "3 mins ago" : "3 mins ago" 
            "John Smith" : "John Smith" 
            "Log Out" : "Log Out" 
            "Settings" : "Settings" 
            "Profile" : "Profile" 
            "Ru" : "Ru" 
            "En" : "En" 
        $translate-provider.translations \ru ,
            "ICO snovio dashboard" : "snovio ICO панель управления"  
            "Thank you for registration. Please" : "Спасибо, что зарегистрировались. Пожалуйста" 
            "confirm your email" : "подтвердите ваш адрес электронной почты" 
            "Copyright © Snov.io 2017" : "Copyright © Snov.io 2017" 
            "Buy now" : "Купить сейчас" 
            "Tokens you hold" : "Ваши токены" 
            "You contributed" : "Внесено" 
            "First week" : "Первая неделя"
            "First day" : "Первый день" 
            "Bonuses:" : "Бонусы:" 
            "Snov token price:" : "Стоимость токена Snov:" 
            "Token crowdsale pool:" : "Пул предпродажи токенов:" 
            "Snov assigned" : "количество Snov" 
            "Address Source" : "Источник адреса" 
            "Transaction ID" : "Номер транзакции" 
            "Date" : "Дата" 
            "Your transaction history" : "История транзакций" 
            "Save changes" : "Сохранить изменения" 
            "Confirm password" : "Подтвердите пароль" 
            "New password" : "Новый пароль"
            "Current password" : "Текущий пароль" 
            "Email" : "Эл. адрес" 
            "Username" : "Имя пользователя" 
            "User Profile" : "Профиль пользователя" 
            "See All Alerts" : "Просмотреть все предупреждения" 
            "Film festivals used to be do-or-die moments for movie makers. They were where..." : "Кинофестивали раньше были для кинорежиссеров, и они были там ..." 
            "3 mins ago" : "3 минуты назад" 
            "John Smith" : "Джон Смит" 
            "Log Out" : "Выход" 
            "Settings" : "Настройки" 
            "Profile" : "Профиль" 
            "Ru" : "Рус" 
            "En" : "Анг" 
        $translate-provider.preferred-language \en
    .run (proofofwork)->
        proofofwork.make \updateProfile
    .controller \profile, ($scope, $http, $local-storage)->
        export form =
            username: ""
            email: ""
            new-password: ""
            new-password-repeat: ""
            old-password: ""
        export save = ->
            return swal "Please try again in 2 seconds" if not $http.defaults.headers.common.request-payment?
            return swal "Passwords do not match" if form.new-password isnt form.new-password-repeat
            return swal "New password cannot be empty" if form.new-password.length is 0
            return swal "Old password cannot be empty" if form.old-password.length is 0
            request = {} <<< form <<< $local-storage
            $http
              .post \/api/updateProfile, request
              .then (resp)->
                  swal "Your profile is changed"
              .catch (resp)->
                  swal resp.data
        $scope <<<< out$
            