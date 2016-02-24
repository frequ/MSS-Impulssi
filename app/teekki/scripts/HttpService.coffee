angular
  .module('teekki')
  .factory 'httpService', ($http) ->

    # use mss domain in production
    # TODO: CORS FAILS IN ANDROID?
    url  = "http://miinasillanpaa.github.io/json/"
    # url = "https://www.miinasillanpaa.fi/impulssi/json/"
    # local url for debugging
    localUrl = "/json/"

    httpService = {}

    _saveCategory = (category) ->
      localStorage.setItem 'activeCategory', JSON.stringify(category)

    httpService.getCategories =  ->
      ## server test (Access-Control Headers are there - > works)
      # $http.get "http://miinasillanpaa.github.io/json/test.json"
      #   .success (data) ->
      #     console.log data
      #     return data
      #   .error (error) ->
      #     console.log 'error', error

      promise = $http.get url + 'categories.json'
        .success (data) ->
          return data
        .error ->
          supersonic.logger.log "error fetching categories.json from #{url}"

    httpService.getRoulette = ->
      promise = $http.get url + 'roulette.json'
        .success (data) ->
          return data
        .error ->
          supersonic.logger.log 'error fetching roulette.json'

    httpService.getCategory = (categoryId) ->
      promise = $http.get url + categoryId + '.json'
        .success (data) ->
          _saveCategory(data)
          return data
        .error ->
          supersonic.logger.log 'error fetching ' + categoryId + '.json'

    return httpService
