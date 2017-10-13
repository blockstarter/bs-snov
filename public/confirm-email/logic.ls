angular
    .module \app, [\ngStorage, \pascalprecht.translate, \members , \proofofwork, \languages ]
    .controller \confirm, ($scope, $http, $local-storage, proofofwork)->
        getUrlParam = (name, url) ->
          if !url
            url = window.location.href
          name = name.replace(/[\[\]]/g, '\\$&')
          regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)')
          results = regex.exec(url)
          if !results
            return null
          if !results.2
            return ''
          decodeURIComponent results.2.replace(/\+/g, ' ')
        export go-to-members = ->
            location.href = \/members/index.html
        export form =
            confirmation-id: getUrlParam \confirmation-id
            confirmed: no
        export resend = ->
            # <-! proofofwork.make \resendConfirmEmail
            $http
              .post \/api/resendConfirmEmail,  { $local-storage.session-id }
              .then ->
                  swal "Please check your mailbox"
              .catch (resp)->
                  swal resp.data
        confirm = ->
            # <-! proofofwork.make \confirmEmail
            $http
              .post \/api/confirmEmail, { form.confirmation-id, ...$local-storage }
              .then ->
                  form.confirmed = yes
              .catch (resp)->
                  swal resp.data
        confirm!
        $scope <<<< out$