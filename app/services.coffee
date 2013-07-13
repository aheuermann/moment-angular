#Demonstrate how to register services
#In this case it is a simple value service.
angular
  .module('app.services', [])
  .value('IMGUR_API', 'https://api.imgur.com/3')
  .service('FileAPI', ($q, $rootScope) ->
    @loadFileData = (f) ->
      d = $q.defer()
      reader = new FileReader()
      reader.onload = (e) ->
        d.resolve(reader.result)
        $rootScope.$apply()
      reader.onerror = ->
        d.reject("Unable to load file")
        $rootScope.$apply()
      reader.readAsDataURL(f)
      d.promise
    this
  )
  .factory('ImgUploadService',($http, $q, IMGUR_API, FileAPI) ->
    headers=
      'Authorization': "Client-ID dd3300b7ef32d64"
    return {
      upload:(d) ->
        $http {
          url: "#{IMGUR_API}/image"
          method: "POST"
          headers: headers
          data:
            image: d.file.substring(d.file.indexOf(',')+1)
            title: d.title
            description: JSON.stringify({date: new Date()})
        }
      get: (id) ->
        $http {
          url: "#{IMGUR_API}/image/#{id}"
          method: "GET"
          headers: headers
        }
    }
  )
  