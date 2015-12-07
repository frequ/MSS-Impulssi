angular
  .module('teekki')
  .controller 'CategoryController', ($scope, supersonic, $sce, httpService) ->

    $scope.lead = null
    $scope.title = null
    $scope.hasSubcategories = false
    $scope.categoryId = null
    $scope.events = null
    $scope.subcategories = null

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

    _fetchCategory = (categoryId) ->
      $scope.categoryId = categoryId;
      httpService.getCategory(categoryId).then (data) ->
        data = data.data
        $scope.title = data.name
        $scope.lead = $sce.trustAsHtml data.lead

        data.subcategories = data.subcategories ? []
        if data.subcategories.length > 0
          _buildSubcategories(data.subcategories)
        else
          $scope.events = data.events

    supersonic.ui.views.current.params.onValue (params) ->
      category_id = params.id
      _fetchCategory(category_id)

    $scope.openUrl = (url) ->
      supersonic.app.openURL(url)
