angular
  .module('teekki')
  .controller 'CategoryController', ($scope, supersonic, $http) ->
    $scope.lead = null
    $scope.title = null
    $scope.hasSubcategories = false
    $scope.categoryId = null
    $scope.events = null
    $scope.subcategories = null

    _saveCategory = (category) ->
      localStorage.setItem 'activeCategory', JSON.stringify(category)

    _buildSubcategories = (subcategories) ->
      $scope.hasSubcategories = true
      subcategoryObjsArray = []

      for subcategory in subcategories
        subcategoryObj = {}
        subcategoryObj.name = subcategory.name
        subcategoryObj.lead = subcategory.lead
        subcategoryObj.id = subcategory.name.replace(/ä/g, "a")
          .replace(/ö/g, "o")
          .split(' ').join('-')
          .toLowerCase()

        subcategoryObjsArray.push subcategoryObj

      $scope.subcategories = subcategoryObjsArray

    _buildEvents = (events) ->
      $scope.events = events

    _fetchCategory = (categoryId) ->
      promise = $http.get '/json/' + categoryId + '.json'
        .success (data) ->
          _saveCategory(data)
          $scope.title = data.name
          $scope.lead = data.lead

          # hack?
          data.subcategories = data.subcategories ? []

          if data.subcategories.length > 0
            _buildSubcategories(data.subcategories)
          else
            _buildEvents(data.events)

        .error ->
          supersonic.logger.log 'error fetching ' + categoryId + '.json'

    supersonic.ui.views.current.params.onValue (params) ->
      category_id = params.id
      _fetchCategory(category_id)

    $scope.openUrl = (url) ->
      supersonic.app.openURL(url)
