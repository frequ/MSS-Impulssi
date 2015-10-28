angular
  .module('teekki')
  .controller 'EventController', ($scope, supersonic, $sce) ->
    $scope.event = null
    $scope.viewTitle = null
    $scope.ytUrl = null

    _fetchEvent = (eventId) ->
      category = JSON.parse(localStorage.getItem "activeCategory")
      eventId = parseInt eventId

      if category.events
        $scope.event = category.events[eventId]
      else
        $scope.event = category[eventId]

      $scope.viewTitle = $scope.event.name

      if $scope.event.videoId
        protocol = location.protocol
        # coffeelint: disable=max_line_length
        $scope.ytUrl = $sce.trustAsResourceUrl protocol + "//www.youtube.com/embed/" + $scope.event.videoId + "?rel=0"
        # coffeelint: enable=max_line_length

    supersonic.ui.views.current.params.onValue (params) ->
      event_id = params.id
      _fetchEvent(event_id)
