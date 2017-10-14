angular
    .module \app, [\ngStorage, \pascalprecht.translate , \proofofwork, \languages ]
    # .run (proofofwork)->
    #     proofofwork.make \forgotPassword
    .controller \restore, ($scope, $http, $local-storage, $translate)->
    
            
        export $local-storage

        export model =
            emailSent: false
        
        export form =
            email: null
            
        export restore = ($event)->
            $event.prevent-default!
            # return swal "Please try again in 2 seconds" if not $http.defaults.headers.common.request-payment?
            return swal "Email is required" if not form.email?
            $http.post \/api/forgotPassword, form 
               .then (resp)->
                   console.log resp.data
                   model.emailSent = true
               .catch (resp)->
                   swal resp.data
        $scope <<<< out$