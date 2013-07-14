angular
  .module('app.directives', [])
  .directive('pickdate', ->
    {
      restrict: 'E'
      scope:
        value: '='
      replace: true
      templateUrl: '/partials/pickdate.html'
      link: (scope, element, attrs) ->
        $(element).pickadate()
    }
  )
  .directive('loading', ->
    {
      restrict: 'E'
      scope: {}
      replace: true
      templateUrl: '/partials/loading.html'
    }
  )
  .directive('map', ->
    {
      restrict: 'E'
      replace: true
      require: '?ngModel'
      templateUrl: '/partials/map.html'
      link: (scope, element, attrs, ngModel) ->
        draw = ->
          html = element.html()
          
          if attrs.stripBr && html == '<br>'
            html = ''

          ngModel.$setViewValue(html)
        ngModel.$render = ->
          element.html ngModel.$viewValue || ''

        element.bind 'blur keyup change', ->
          scope.$apply draw

        draw()

      ###controller: ($scope) ->
        console.log $scope.place
        ll = new google.maps.LatLng(28.0810, 80.2740);
        $scope.mapOptions =
          center: ll,
          zoom: 15,
          mapTypeId: google.maps.MapTypeId.ROADMAP

        $scope.onMapIdle = ->
          unless $scope.myMarkers
            marker = new google.maps.Marker {
              map: $scope.myMap
              position: ll
            }
            $scope.myMarkers = [marker]

        $scope.markerClicked = (m) ->
          window.alert("clicked")###
    }

  )
