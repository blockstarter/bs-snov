angular
    .module \app, [\ngStorage, \pascalprecht.translate , \members , \proofofwork, \languages ]
    # .run (proofofwork)->
    #     proofofwork.make \updateProfile
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
            # return swal "Please try again in 2 seconds" if not $http.defaults.headers.common.request-payment?
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
            