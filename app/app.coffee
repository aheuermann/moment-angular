# Declare app level module which depends on filters, and services
angular.module('app', [
  'ui.bootstrap'
  'google-maps'
  'ngCookies'
  'ngResource'
  'app.controllers'
  'app.directives'
  'app.filters'
  'app.services'
])
.config(($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode(true);
  $routeProvider
    .when('/record', {templateUrl: '/partials/record.html', controller:"RecordCtrl"})
    .when('/v/:id', {templateUrl: '/partials/view.html', controller:'ViewCtrl', resolve: {data: (ViewCtrlDataResolver)->  ViewCtrlDataResolver.get()}})
    .when('/recent', {templateUrl: '/partials/view_all.html', controller:'ViewAllCtrl', resolve: {data: (ViewCtrlDataResolver)->  ViewCtrlDataResolver.getAll()}})

    # Catch all
    .otherwise({redirectTo: '/recent'})
)
.config(($httpProvider)->
  delete $httpProvider.defaults.headers.common["X-Requested-With"]
)
.run(->
  developemnt = window.location.hostname is 'localhost'
  window.C=
    API_URL: if developemnt then 'http://localhost:8080' else 'http://moment-api.herokuapp.com'

)

AppCtrl = ($scope, $rootScope, $location, $timeout) ->
  $rootScope.triggerAlert = (type, message, autoClear=false) ->
    $rootScope.alert= true
    $rootScope.alertType= type
    $rootScope.alertMessage= message
    if autoClear
      $timeout -> 
        $rootScope.clearAlert()
      , 1000
  $rootScope.triggerError = (message="Oops, that wasn't supposed to happen. Please try again...") ->
    $rootScope.triggerAlert 'alert-error', message
  $rootScope.clearAlert = ->
    $rootScope.alert= false


  $rootScope.$on "$routeChangeStart", (event, next, current) ->
    $scope.triggerAlert "alert-info", "Loading..."
  $rootScope.$on "$routeChangeSuccess", (event, current, previous) ->
    $scope.clearAlert()
    $scope.newLocation = $location.path()
  $rootScope.$on "$routeChangeError", (event, current, previous, rejection) ->
    $scope.triggerAlert "alert-error", "Error: #{rejection}"
  $rootScope.clearAlert()