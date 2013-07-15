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