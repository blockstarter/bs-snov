
angular
    .module \app, [\ngStorage, \pascalprecht.translate , \proofofwork, \languages ]
    .run (proofofwork)->
        proofofwork.make \auth
    .controller \login, ($scope, $http, $local-storage, $location)->
        url-param = (name) ->
            results = new RegExp('[?&]' + name + '=([^&#]*)').exec(window.location.href)
            if results == null
                null
            else
                results.1 or 0
        utm_label = $location.hash!
        $location.hash ""
        export form =
            email: null
            username: ""
            password: null
            reference: utm_label ? \native
            accept-location: no 
            accept-privacy: no
            autoregister: no
        export register = (bool)->
            form.autoregister = bool
        export enter = ($event)->
            $event.prevent-default!
            return swal "Please try again in 2 seconds" if not $http.defaults.headers.common.request-payment?
            return swal "Please accept location" if not form.accept-location
            return swal "Please accept privacy" if not form.accept-privacy
            return swal "Email is required" if not form.email?
            return swal "Password is required" if not form.password?
            
            $http.post \/api/auth, form
            
               .then (resp)->
                   { $local-storage.session-id } = resp.data
                   { location.href } = $event.target
               .catch (resp)->
                   swal resp.data
        $scope <<<< out$
            