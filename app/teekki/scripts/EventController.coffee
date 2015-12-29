angular
  .module('teekki')
  .controller 'EventController', ($scope, supersonic, $sce) ->

    $scope.event = null
    $scope.viewTitle = null
    $scope.videoId = null

    _fetchEvent = (eventId) ->
      category = JSON.parse(localStorage.getItem "activeCategory")
      eventId = parseInt eventId

      if category.events
        $scope.event = category.events[eventId]
      else
        $scope.event = category[eventId]

      $scope.viewTitle = $scope.event.name

      if $scope.event.videoId
        $scope.videoId = $scope.event.videoId

    supersonic.ui.views.current.params.onValue (params) ->
      event_id = params.id
      _fetchEvent(event_id)
