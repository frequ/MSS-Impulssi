angular
  .module('teekki')
  .controller 'IndexController', ($scope, supersonic, httpService) ->

    $scope.categories = null
    $scope.rouletteContent = null

    _fetchCategories =  ->
      supersonic.ui.dialog.spinner.show("Ladataan sisältöä..")
      httpService.getCategories()
        .then (data) ->
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

        .catch (error) ->
          supersonic.logger.error error.message

        .finally ->
          supersonic.ui.dialog.spinner.hide()

    _fetchCategories()

    $scope.enableRoulette = ->
      rouletteView = new supersonic.ui.View "teekki#roulette"
      supersonic.ui.layers.push rouletteView
