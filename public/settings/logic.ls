angular
    .module \app, [\ngStorage, \pascalprecht.translate, \members , \proofofwork, \languages ]
    # .run (proofofwork)->
    #     proofofwork.make \updateProfile
    .controller \settings, ($scope, $http, $local-storage, $root-scope)->
        web3 = new Web3! # web3 is used only to verify Ethereum addresses on Settings page.
        export form =
            address: ""
        $root-scope.$watch \user, (value)->
            return if not value?profile?address
            if value.profile.address.index-of('0x') > -1
               form.address = value.profile.address
        export confirm = ->
            # return swal "Please try again in 2 seconds" if not $http.defaults.headers.common.request-payment?
            return swal "Please enter a valid Ethereum address" if not web3.isAddress form.address
            $http
              .post \/api/updateProfile, { form.address, ...$local-storage }
              .then ->
                  location.href = \/members/index.html
                  #swal "Done"
              .catch (resp)->
                  swal resp.data
        $scope <<<< out$