angular
  .module('teekki')
  .controller 'IndexController', ($scope, supersonic, $http, $rootScope) ->
    $scope.categories = null
    $scope.rouletteContent = null
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

    _fetchRoulette = ->
      promise = $http.get '/json/roulette.json'
        .success (data) ->
          $scope.rouletteContent = data
        .error ->
          supersonic.logger.log 'error fetching roulette.json'

    _fetchRoulette()

    $scope.enableRoulette = ->
      $rootScope.showRoulette = true
      supersonic.ui.animate('slideFromRight').perform()
