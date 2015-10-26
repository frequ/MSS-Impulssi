angular
  .module('teekki')
  .directive 'roulette', ($interval, $timeout) ->
    restrict: 'E',
    templateUrl: '/app/teekki/roulette.html',
    scope: {
      content: '='
    },
    link: (scope, element) ->
      scope.running = false

      scope.back = ->
        scope.$parent.showRoulette = false
        supersonic.ui.animate('slideFromLeft').perform()
        reset()

      scope.spin = ->
        scope.running = true
        mainLoop()

      scope.$watch 'content', (newVal, oldVal) ->
        if newVal.length > 0
          scope.content = newVal
          _buildRoulette(scope, scope.content)

      move = (marginTop) ->
        jQuery('.spinner-item-wrap').css('margin-top', marginTop + "px")

      mainLoop = ->
        spinnerPos = -1
        roundDone = 0
        totalRounds = 4
        spinnerMoveInterval = 25
        stopRecursiveCalling = false
        slotHeight = 49

        timeout ( ->
          scope.looper = $timeout ->
            spinnerPos -= 4

            if spinnerPos <= -289
              spinnrPos = -1
              roundDone++

            else if roundsDone >= totalRounds
              spinnerMoveInterval += 1

              if spinnerMoveInterval >= 75
                stopPosition = Math.round(spinnerPos / slotHeight * slotHeight)+3
                winnerEvent = scope.items[5]
                $timeout.cancel(scope.looper)
                stopRecursiveCalling = true

                scope.finalInterval = $interval ( ->
                  if spinnerPos is stopPosition
                    $interval.cancel(scope.finalInterval)

                    $timeout ( ->
                      # todo show event
                    ), 500
                    $timeout ( ->
                      reset()
                    ), 1500

                  else if spinnerPos < stopPosition
                    spinnerPos++
                  else if spinnerPos > stopPosition
                    spinnerPos--

                  move(spinnerPos)

                ), spinnerMoveInterval

            if !stopRecursiveCalling
              timeout()

          ), spinnerMoveInterval

        timeout()

      _shuffle = (array) ->
        currentIndex = array.length

        while currentIndex isnt 0
          randomIndex = Math.floor(Math.random() * currentIndex)
          currentIndex -= 1
          tempValue = array[currentIndex]
          array[currentIndex] = array[randomIndex]
          array[randomIndex] = tempValue

        array

      _buildRoulette = (scope, content) ->
        scope.items = []
        items = _shuffle(content)
        repeat = items.lice(0,3)
        items = items.splice(0,6)
        scope.items = items.concat(repeat)
        move(-1)

      reset = ->
        scope.running = false
        _buildRoulette(scope, scope.content)
        $timeout.cancel(scope.looper)
        $interval.cancel(scope.finalInterval)
