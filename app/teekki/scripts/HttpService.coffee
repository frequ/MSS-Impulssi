angular
  .module('teekki')
  .factory 'httpService', ($http) ->

    url = "http://miinasillanpaa.github.io/mobile-json-v1.2/"

    # local url for debugging
    # url = "/json/"
    # url = "http://192.168.1.40:8888/miinasillanpaa.github.io/json-v1.2/"

    httpService = {}

    _saveCategory = (category) ->
      localStorage.setItem 'activeCategory', JSON.stringify(category)

    httpService.getCategories =  ->
      $http.get url + 'categories.json'
        .success (data) ->
          data
        .error ->
          supersonic.logger.log "error fetching categories.json from #{url}"

    httpService.getRoulette = ->
      $http.get url + 'roulette.json'
        .success (data) ->
          data
        .error ->
          supersonic.logger.log 'error fetching roulette.json'

    httpService.getCategory = (categoryId) ->
      $http.get url + categoryId + '.json'
        .success (data) ->
          _saveCategory(data)
          data
        .error ->
          supersonic.logger.log 'error fetching ' + categoryId + '.json'

    httpService
