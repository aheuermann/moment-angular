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
        else
          $scope.formData.file = null

    $scope.getPlaces= (a) ->
      API.placeSuggest($scope.formData.placeText)

    $scope.onSelect = ($item, $model, $label)->
      $scope.formData.place = $item

    $scope.record = ->
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
          .error(-> $scope.triggerError())
        )
        .error(-> $scope.triggerError())
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
  .service('ViewCtrlDataResolver', ($q, $route, API) ->
    return {
      get: ->
        d = $q.defer()
        id= $route.current.params.id
        API.get(id)
        .success((response, status, headers, config) ->
          if response.date
            response.date = Date.parseIso8601 response.date 
            response.dateFormatted = moment(response.date).format 'dddd MMMM Do, YYYY'
          if response.created_at
            response.created_at = Date.parseIso8601 response.created_at
            response.createFormatted = moment(response.created_at).format 'dddd MMMM Do, YYYY'
          d.resolve response
        ).error((data, status, headers, config) ->
          d.resolve "Error"
        )
        d.promise
    }
  )


