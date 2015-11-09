angular
  .module('teekki')
  .controller 'SubcategoryController', ($scope, supersonic, $sce) ->

    $scope.events = null

    _idfySubcategoryName = (subcategory) ->
      subcategory.replace(/ä/g, "a")
        .replace(/ö/g, "o").split(' ')
        .join('-').toLowerCase()

    _fetchSubcategory = (subcategoryId) ->
      category = JSON.parse(localStorage.getItem "activeCategory")
      events = category.events
      subcategories = category.subcategories

      # coffeelint: disable=max_line_length
      subcategory = (subcategory for subcategory in subcategories when _idfySubcategoryName(subcategory.name) is subcategoryId)[0]
      $scope.events = (event for event in events when _idfySubcategoryName(event.belongsTo) is subcategoryId)
      # coffeelint: enable=max_line_length

      $scope.viewTitle = subcategory.name
      $scope.eventsLead = $sce.trustAsHtml subcategory.lead

    supersonic.ui.views.current.params.onValue (params) ->
      subcategory_id = params.id
      _fetchSubcategory(subcategory_id)

    $scope.openUrl = (url) ->
      supersonic.app.openURL(url)
