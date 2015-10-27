angular
  .module('teekki')
  .directive 'roulette', ($interval, $timeout, $rootScope) ->
    restrict: 'E',
    templateUrl: '_roulette.html',
    scope: {
      content: '='
    },
    link: (scope, element) ->
      scope.running = false
      scope.items = null
      scope.changingSpinnerPos = null

      scope.$watch 'content', (newVal, oldVal) ->
        if newVal && newVal.length > 0
          localStorage.setItem 'activeCategory', JSON.stringify(newVal)
          scope.content = newVal
          _buildRoulette(scope.content)

      scope.back = ->
        $rootScope.showRoulette = false
        supersonic.ui.animate('slideFromLeft').perform()
        _reset()

      scope.spin = ->
        scope.running = true
        _mainLoop()

      _move = (marginTop) ->
        element = document.querySelector('.spinner-item-wrap')
        angular.element(element).css('margin-top', marginTop + "px")

      intervals = []
      _interval = (ms, func) -> intervals.push ($interval func, ms)

      _finalInterval = (spinnerPos, stopPos, winEvent) ->
        if !scope.changingSpinnerPos
          scope.changingSpinnerPos = spinnerPos

        if scope.changingSpinnerPos == stopPos
          _clearIntervals()

          $timeout ( ->
            # coffeelint: disable=max_line_length
            winEventView = new supersonic.ui.View "teekki#event?id=" + winEvent.id
            # coffeelint: enable=max_line_length
            supersonic.ui.layers.push winEventView
          ), 500

          $timeout ( ->
            _reset()
          ), 2500

        else if scope.changingSpinnerPos < stopPos
          scope.changingSpinnerPos++
        else if scope.changingSpinnerPos > stopPos
          scope.changingSpinnerPos--

        _move(scope.changingSpinnerPos)

      _mainLoop = ->
        spinnerPos = -1
        roundsDone = 0
        totalRounds = 4
        spinnerMoveIntervalMS = 25
        stopRecursiveCalling = false
        slotHeight = 49

        recursiveTimeout = ->
          scope.looper = $timeout ( ->
            spinnerPos -= 4
            _move(spinnerPos)

            if spinnerPos <= -289
              # reset spinner so it seems to be going around
              spinnerPos = -1
              roundsDone++
              _move(spinnerPos)

            else if roundsDone >= totalRounds
              # slow down spinner
              spinnerMoveIntervalMS += 1

              if spinnerMoveIntervalMS >= 75
                stopPos = Math.round(spinnerPos / slotHeight * slotHeight)+8
                winnerEvent = scope.items[5]
                $timeout.cancel scope.looper
                stopRecursiveCalling = true
                # coffeelint: disable=max_line_length
                _interval spinnerMoveIntervalMS, -> _finalInterval spinnerPos, stopPos, winnerEvent
                # coffeelint: enable=max_line_length

            if !stopRecursiveCalling
              recursiveTimeout()

          ), spinnerMoveIntervalMS

        recursiveTimeout()

      _clearIntervals = ->
        $interval.cancel interval for interval in intervals
        intervals = []

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
        scope.items = []
        items = _shuffle(content)
        repeat = items.slice(0,3)
        items = items.splice(0,6)
        scope.items = items.concat(repeat)
        _move(-1)

      _reset = ->
        scope.running = false
        scope.changingSpinnerPos = null
        _buildRoulette(scope.content)
        $timeout.cancel(scope.looper)
        $interval.cancel(scope.finalInterval)
