angular.module('app.controllers', [])
  .controller('RecordCtrl', ($scope, $location, ImgUploadService, FileAPI, PlacesService) ->
    $scope.formData = {}
    $scope.setFile = (element) ->
      $scope.$apply ($scope) ->
        files = element.files
        if files and files.length > 0
          FileAPI.loadFileData(files[0])
            .then (data) -> 
              $scope.formData.file = data
              console.log $scope.formData.fileData 
            , -> 
              console.log "ERRORORRORORORORORO"
        else
          $scope.formData.file = null

    $scope.getPlaces= (a) ->
      PlacesService.suggest($scope.formData.placeText)

    $scope.onSelect = ($item, $model, $label)->
      $scope.formData.place = $item

    $scope.record = ->
      $scope.formData.date = new Date()
      ImgUploadService.upload($scope.formData)
      .success((data, status, headers, config) ->
        $location.path("/v/#{data.data.id}")
      ).error((data, status, headers, config) ->
        console.log "ERROR"
        console.log data
        console.log status
      )
  )
  .controller('ViewCtrl', ($scope, ViewCtrlData) ->
    $scope.d = ViewCtrlData
  )
  .factory('ViewCtrlData', ($q, $route, ImgUploadService) ->
    d = $q.defer()
    id= $route.current.params.id
    ImgUploadService.get(id)
    .success((response, status, headers, config) ->
      data = response.data
      data.description = $.parseJSON(data.description)
      d.resolve response.data
    ).error((data, status, headers, config) ->
      d.resolve "Error"
    )
    d.promise
  )


