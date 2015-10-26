angular
  .module('teekki')
  .controller 'RouletteController', ($scope, supersonic, $http, $interval, $timeout, $rootScope) ->
    $scope.data = null
    $scope.items = null
    $scope.running = false
    $scope.changingSpinnerPos = null

    $scope.back = ->
      $rootScope.showRoulette = false
      supersonic.ui.animate('slideFromLeft').perform()

    $scope.spin = ->
      $scope.running = true
      _mainLoop()

    _move = (marginTop) ->
      element = document.querySelector('.spinner-item-wrap')
      angular.element(element).css('margin-top', marginTop + "px")

    intervals = []
    _interval = (ms, func) -> intervals.push ($interval func, ms)

    $scope.finalInterval = (spinnerPos, stopPos, winEvent) ->
      if !$scope.changingSpinnerPos
        $scope.changingSpinnerPos = spinnerPos

      if $scope.changingSpinnerPos == stopPos

        _clearIntervals()

        $timeout ( ->
          winEventView = new supersonic.ui.View "teekki#event?id=" + winEvent.id
          supersonic.ui.layers.push winEventView
        ), 500
        $timeout ( ->
          _reset()
        ), 2500
      else if $scope.changingSpinnerPos < stopPos
        $scope.changingSpinnerPos++
      else if $scope.changingSpinnerPos > stopPos
        $scope.changingSpinnerPos--

      _move($scope.changingSpinnerPos)


    _mainLoop = ->
      spinnerPos = -1
      roundsDone = 0
      totalRounds = 4
      spinnerMoveInterval = 25
      stopRecursiveCalling = false
      slotHeight = 49

      recursiveTimeout = ->
        $scope.looper = $timeout ( ->
          spinnerPos -= 4
          _move(spinnerPos)

          if spinnerPos <= -289
            # reset spinner so it seems to be going around
            spinnerPos = -1
            roundsDone++
            _move(spinnerPos)

          else if roundsDone >= totalRounds
            # slow down spinner
            spinnerMoveInterval += 1

            if spinnerMoveInterval >= 75
              stopPos = Math.round(spinnerPos / slotHeight * slotHeight)+8
              winnerEvent = $scope.items[5]
              $timeout.cancel($scope.looper)
              stopRecursiveCalling = true
              _interval spinnerMoveInterval, -> $scope.finalInterval spinnerPos, stopPos, winnerEvent

          if !stopRecursiveCalling
            recursiveTimeout()

        ), spinnerMoveInterval

      recursiveTimeout()

    _clearIntervals = ->
      $interval.cancel interval for interval in intervals
      intervals = []

    _reset = ->
      $scope.running = false
      _buildRoulette($scope.data)
      $timeout.cancel($scope.looper)
      _clearIntervals()


    _shuffle = (array) ->
      currentIndex = array.length

      while currentIndex isnt 0
        randomIndex = Math.floor(Math.random() * currentIndex)
        currentIndex -= 1
        tempValue = array[currentIndex]
        array[currentIndex] = array[randomIndex]
        array[randomIndex] = tempValue

      array

    _buildRoulette = (content) ->
      items = _shuffle(content)
      repeat = items.slice(0,3)
      items = items.splice(0,6)
      $scope.items = items.concat(repeat)
      _move(-1)

    _fetchRoulette = ->
      promise = $http.get '/json/roulette.json'
        .success (data) ->
          localStorage.setItem 'activeCategory', JSON.stringify(data)
          console.log 'localstorage has roulette category'
          $scope.data = data
          _buildRoulette(data)
        .error ->
          supersonic.logger.warn 'Error fetching roulette.json'

    $scope.$on 'fetchRoulette', ->
      _fetchRoulette()
