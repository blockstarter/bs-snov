
angular
    .module \app, [\ngStorage, \pascalprecht.translate , \proofofwork, \languages ]
    # .run (proofofwork)->
    #     proofofwork.make \auth
    .controller \login, ($scope, $http, $local-storage)->
        url-param = (name) ->
            results = new RegExp('[?&]' + name + '=([^&#]*)').exec(window.location.href)
            if results == null
                null
            else
                results.1 or 0
        utm_label = Cookies.get \utm
        export form =
            email: null
            username: ""
            password: null
            reference: utm_label ? \native
            accept-location: no 
            accept-privacy: no
            saft-agreement: no
            token-risks: no
            autoregister: no
        export register = (bool)->
            form.autoregister = bool
        export enter = ($event)->
            $event.prevent-default!
            # return swal "Please try again in 2 seconds" if not $http.defaults.headers.common.request-payment?
            return swal "Please accept location" if location.hash is \#signup and not form.accept-location
            return swal "Please accept privacy" if location.hash is \#signup and not form.accept-privacy
            return swal "Please accept SAFT agreement" if location.hash is \#signup and not form.saft-agreement
            return swal "Please accept risks" if location.hash is \#signup and not form.token-risks
            return swal "Email is required" if not form.email?
            return swal "Please put valid email" if location.hash is \#signup and form.email.index-of(\@) is -1
            return swal "Password is required" if not form.password?
            
            $http
               .post \/api/auth, form
               .then (resp)->
                   { $local-storage.session-id } = resp.data
                   { location.href } = $event.target
               .catch (resp)->
                   swal resp.data
        $scope <<<< out$