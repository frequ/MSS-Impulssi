angular
  .module('teekki')
  .factory 'httpService', ($http) ->

    # use mss domain in production
    # url = "https://www.miinasillanpaa.fi/hh/json/"
    # local url for debugging
    url = "/json/"

    httpService = {}

    _saveCategory = (category) ->
      localStorage.setItem 'activeCategory', JSON.stringify(category)

    httpService.getCategories = ->
      promise = $http.get url + 'categories.json'
        .success (data) ->
          return data
        .error ->
          supersonic.logger.log 'error fetching categories.json'

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
