angular
  .module('app.controllers', [])
  .controller('RecordCtrl', ($scope, $location, ImgUploadService, FileAPI) ->
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

    $scope.record = ->
      ImgUploadService.upload($scope.formData)
      .success((data, status, headers, config) ->
        $location.path("/v/#{data.data.id}")
      ).error((data, status, headers, config) ->
        console.log "ERROR"
        console.log data
        console.log status
      )
  )
  .controller('ViewCtrl', ($scope, $routeParams, ImgUploadService) ->
    ImgUploadService.get($routeParams.id)
    .success((data, status, headers, config) ->
      d = data.data
      d.description = $.parseJSON(d.description)
      d.dateFormatted = moment(d.description.date).format 'dddd MMMM Do YYYY'
      $scope.d = d

    ).error((data, status, headers, config) ->
      console.log "ERROR"
      console.log data
      console.log status
    )
  )