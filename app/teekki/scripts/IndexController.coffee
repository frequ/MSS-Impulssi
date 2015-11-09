angular
  .module('teekki')
  .controller 'IndexController', ($scope, supersonic, $rootScope, httpService) ->

    $scope.categories = null
    $scope.rouletteContent = null
    $rootScope.showRoulette = false

    _fetchCategories =  ->
      httpService.getCategories().then (data) ->
        data = data.data
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

    _fetchCategories()

    _fetchRoulette = ->
      httpService.getRoulette().then (data) ->
        data = data.data
        $scope.rouletteContent = data

    _fetchRoulette()

    $scope.enableRoulette = ->
      $rootScope.showRoulette = true
      supersonic.ui.animate('slideFromRight').perform()

      # coffeelint: disable=max_line_length
      localStorage.setItem 'activeCategory', JSON.stringify($scope.rouletteContent)
      # coffeelint: enable=max_line_length
