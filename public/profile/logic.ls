angular
    .module \app, [\ngStorage, \pascalprecht.translate , \members , \proofofwork ]
    .config ($translate-provider) ->
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
    .controller \profile, ($scope, $http, $local-storage, $root-scope)->
        export form =
            username: ""
            email: ""
            new-password: ""
            new-password-repeat: ""
            old-password: ""
        $root-scope.$watch \user, (value)->
            return if not value?profile?address
            form.username = value.profile.name
            form.email = value.profile.email
        export save = ->
            return swal "Please try again in 2 seconds" if not $http.defaults.headers.common.request-payment?
            return swal "Passwords do not match" if form.new-password isnt form.new-password-repeat
            return swal "New password cannot be empty" if form.new-password.length is 0
            return swal "Old password cannot be empty" if form.old-password.length is 0
            request = {} <<< form <<< $local-storage
            $http
              .post \/api/updateProfile, request
              .then (resp)->
                  location.href = \/members/index.html
                  #swal "Your profile is changed"
              .catch (resp)->
                  swal resp.data
                  
        $scope <<<< out$
            