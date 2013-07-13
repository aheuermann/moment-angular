#Demonstrate how to register services
#In this case it is a simple value service.
angular
  .module('app.services', [])
  .value('ImgService',($http, $q, Session) ->
    return {
      upload: ()->
        d = $q.defer()
        $http({
          url: "#{C.API_URL}/courses"
          method: "GET"
          params: {creator:creator}
        }).success((data, status, headers, config) ->
          d.resolve data
        ).error((data, status, headers, config) ->
          d.resolve []
        )
        d.promise
    }
  )