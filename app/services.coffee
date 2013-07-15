

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
        console.log d
        $http {
          url: "#{IMGUR_API}/image"
          method: "POST"
          headers: headers
          data:
            image: d.file.substring(d.file.indexOf(',')+1)
            title: d.title
        }
      get: (id) ->
        $http {
          url: "#{IMGUR_API}/image/#{id}"
          method: "GET"
          headers: headers
        }
    }
  )
  .value('GOOGLE_KEY', 'AIzaSyAQSxsZkYb7X5Iji9xNi0JmNWi7lsGftJE')
  .factory('API', ($q, $http, GOOGLE_KEY) ->
    return {
      placeSuggest: (q) ->
        $http.get("http://localhost:8080/place/search", {params: {q:q}})
        .then((response) ->
          return response.data?.predictions
        )
      get: (id) ->
        $http.get("http://localhost:8080/moment/#{id}")
      save: (data) ->
        $http.post("http://localhost:8080/moment", data)

    }
  )
  