angular
    .module \app, [\ngStorage, \pascalprecht.translate, \members , \proofofwork ]
    .config ($translate-provider) ->
        $translate-provider.translations \en , 
            "Copyright © Snov.io 2017" : "Copyright © Snov.io 2017" 
        $translate-provider.translations \ru ,
            "Copyright © Snov.io 2017" : "Copyright © Snov.io 2017" 
        $translate-provider.preferred-language \en
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
        confirm = ->
            <-! proofofwork.make \confirmEmail
            $http
              .post \/api/confirmEmail, { form.confirmation-id, ...$local-storage }
              .then ->
                  form.confirmed = yes
              .catch (resp)->
                  swal resp.data
        confirm!
        $scope <<<< out$