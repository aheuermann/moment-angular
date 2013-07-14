# Declare app level module which depends on filters, and services
angular.module('app', [
  'ui.bootstrap'
  'ui.map'
  'ngCookies'
  'ngResource'
  'app.controllers'
  'app.directives'
  'app.filters'
  'app.services'
])
.config(($routeProvider, $locationProvider) ->
  $routeProvider
    .when('/record', {templateUrl: '/partials/record.html', controller:"RecordCtrl"})
    .when('/v/:id', {templateUrl: '/partials/view.html', controller:'ViewCtrl', resolve: ['ViewCtrlData']})

    # Catch all
    .otherwise({redirectTo: '/view1'})
)
.config(($httpProvider)->
  delete $httpProvider.defaults.headers.common["X-Requested-With"]
)

AppCtrl = ($scope, $rootScope, $location) ->
  $rootScope.$on "$routeChangeStart", (event, next, current) ->
    $scope.alertType = "alert-info"
    $scope.alertMessage = "Loading..."
    $scope.alert = true
  $rootScope.$on "$routeChangeSuccess", (event, current, previous) ->
    #$scope.alertType = "alert-success"
    #$scope.alertMessage = "Successfully changed routes :)"
    $scope.alert = false
    $scope.newLocation = $location.path()
  $rootScope.$on "$routeChangeError", (event, current, previous, rejection) ->
    $scope.alertType = "alert-error"
    $scope.alertMessage = "Error: #{rejection}"
    $scope.alert = true
  $scope.alert = false
  $scope.alertType= 'alert-info'