# Declare app level module which depends on filters, and services
angular.module('app', [
  'ui.bootstrap'
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
    .when('/v/:id', {templateUrl: '/partials/view.html', controller:"ViewCtrl"})

    # Catch all
    .otherwise({redirectTo: '/view1'})
)
.config(($httpProvider)->
  delete $httpProvider.defaults.headers.common["X-Requested-With"]
)
