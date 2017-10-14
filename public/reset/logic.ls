angular
    .module \app, [\ngStorage, \pascalprecht.translate , \proofofwork, \languages ]
    # .run (proofofwork)->
    #     proofofwork.make \resetPassword
    .controller \restore, ($scope, $http, $local-storage, $translate)->
            
        export $local-storage
        
        getUrlParam = (name, url) ->
          if !url
            url = window.location.href
          name = name.replace(/[\[\]]/g, '\\$&')
          regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)')
          results = regex.exec(url)
          if !results
            return null
          if !results[2]
            return ''
          decodeURIComponent results.2.replace(/\+/g, ' ')

        export model =
            passwordReset: false
        
        export form =
            new-password: null
            new-password-again: null
            restoreKey: getUrlParam 'restore-key'
            
        export reset = ($event)->
            $event.prevent-default!
            # return swal "Please try again in 2 seconds" if not $http.defaults.headers.common.request-payment?
            return swal "New password is required" if not form.new-password?
            return swal "Repeat your new password" if not form.new-password-again?
            return swal "Passwords do not match" if form.new-password-again isnt form.new-password
            
            $http.post \/api/resetPassword, form 
               .then (resp)->
                   model.passwordReset = true
               .catch (resp)->
                   swal resp.data
                   
        $scope <<<< out$
        window.ngscope = {} <<<< out$