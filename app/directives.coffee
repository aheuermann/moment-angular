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
          console.log $(element).pickadate()
      }
  )