angular
    .module \app, [\flyber, \ngStorage, \pascalprecht.translate ]
    .config ($translate-provider) ->
        $translate-provider.translations \en , 
            "Forgot password" : "Forgot password" 
            "Please enter your email so we can send you a link to restore the access to your account." : "Please enter your email so we can send you a link to restore the access to your account." 
            "Restore the access to your account" : "Restore the access to your account" 
        $translate-provider.translations \ru ,
            "Forgot password" : "Забыли пароль" 
            "Please enter your email so we can send you a link to restore the access to your account." : "Пожалуйста, введите адрес электронной почты, чтобы мы могли отправить вам ссылку для восстановления доступа к вашей учетной записи." 
            "Restore the access to your account" : "Восстановить доступ к вашей учетной записи" 
        $translate-provider.preferred-language \en
    .controller \restore, ($scope, $http, $local-storage)->
        
        #$scope <<<< out$