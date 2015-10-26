angular
  .module('teekki')
  .directive 'compile', ($compile, supersonic) ->
    restrict: 'A',
    replace: true,
    link: (scope, element, attrs) ->

      scope.url = undefined

      scope.openUrl = ->
        supersonic.app.openURL scope.url

      scope.$watch attrs.compile, (html) ->
        if attrs.url
          scope.url = attrs.url
          index = html.indexOf('<button') + 7
          # coffeelint: disable=max_line_length
          html = html.slice(0,index) + " ng-click=\"openUrl()\" " + html.slice(index)
          # coffeelint: enable=max_line_length

        element.html html
        $compile(element.contents())(scope)
