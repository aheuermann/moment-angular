angular.module('app.controllers', [])
  .controller('RecordCtrl', ($scope, $location, ImgUploadService, FileAPI, API) ->
    $scope.formData = {}
    $scope.setFile = (element) ->
      $scope.$apply ($scope) ->
        files = element.files
        if files and files.length > 0
          FileAPI.loadFileData(files[0])
            .then (data) -> 
              $scope.formData.file = data
            , -> 
              $scope.triggerError()
    $scope.imgDialog= ->
      #move this to a directive for a img upload
      setTimeout ->
        $('input[type=file]').click() 
      , 0

    $scope.removeImg= ->
      $scope.formData.file = null
    $scope.getPlaces= (a) ->
      API.placeSuggest($scope.formData.placeText)

    $scope.onSelect = ($item, $model, $label)->
      $scope.formData.place = $item

    $scope.record = ->
      $scope.saveDisabled = true
      $('html, body').animate({ scrollTop: 0 }, 1000)
      $scope.triggerAlert 'alert-info', 'Uploading...'
      ImgUploadService.upload($scope.formData)
        .success((data, status, headers, config) ->
          $scope.triggerAlert 'alert-info', 'Saving...'
          r =
            title: $scope.formData.title
            imgRef: data.data.id
            imgLink: data.data.link
            placeRef: $scope.formData.place.reference
            placeTitle: $scope.formData.place.description
            imgDelete: data.data.deletehash
            date: new Date()
          API.save(r)
          .success((data) ->
            $scope.triggerAlert 'alert-success', 'Saved!', true
            $location.path("/v/#{data.id}")
          )
          .error(-> $scope.saveDisabled = false; $scope.triggerError())
        )
        .error(-> $scope.saveDisabled = false; $scope.triggerError())
  )
  .controller('ViewCtrl', ($scope, data) ->
    google.maps.visualRefresh = true
    $scope.d = data
    loc = {latitude:data.loc[0], longitude: data.loc[1]}
    angular.extend $scope, {
      position:
        coords: loc
      centerProperty: loc
      zoomProperty: 15
      markersProperty: [loc]
      clickedLatitudeProperty: null 
      clickedLongitudeProperty: null
    }
  )
  .controller('ViewAllCtrl', ($scope, data) ->
    $scope.recentMoments = data
  )
  .service('ViewCtrlDataResolver', ($q, $route, API, $rootScope) ->
    return {
      get: ->
        d = $q.defer()
        id= $route.current.params.id
        API.get(id)
        .success((response, status, headers, config) ->
          if response.date
            response.date = Date.parseIso8601 response.date 
            response.dateFormatted = moment(response.date).format 'dddd MMMM Do, YYYY'
          d.resolve response
        )
        .error((data, status, headers, config) ->
          d.resolve "Error"
        )
        d.promise
      getAll: ->
        d = $q.defer()
        API.getAll()
        .success((response, status, headers, config) ->
          for r in response
            r.date = Date.parseIso8601 r.date
            r.dateFormatted = moment(r.date).format 'dddd MMMM Do, YYYY' 
          d.resolve response
        )
        .error((data, status, headers, config) ->
          d.resolve "Error"
        )
        d.promise
    }
  )


