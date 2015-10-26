angular
  .module('teekki')
  .controller 'IndexController', ($scope, supersonic, $http, $rootScope) ->
    $scope.categories = null
    $rootScope.showRoulette = false

    _fetchCategories =  ->
      promise = $http.get '/json/categories.json'
        .success (data) ->

          categories = []

          for item in data
            categoryObj = {}
            categoryObj.name = item
            categoryObj.id = item.replace(/ä/g, "a")
              .replace(/ö/g, "o")
              .split(' ')
              .join('-').toLowerCase()

            categories.push categoryObj

          $scope.categories = categories
        .error ->
          supersonic.logger.log 'error fetching categories.json'

    _fetchCategories()

    $scope.enableRoulette = ->
      $rootScope.$broadcast('fetchRoulette')
      $rootScope.showRoulette = true
      supersonic.ui.animate('slideFromRight').perform()
