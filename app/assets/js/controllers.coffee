dkCalculatorAppControllers = angular.module 'dkCalculatorAppControllers', []

dkCalculatorAppControllers.controller 'MainController', ['$scope', '$http', '$location', 'geolocationService', 'utilsService', ($scope, $http, $location, geolocationService, utilsService) ->

  geolocationService().then ((position) ->
    $scope.position = position
  ), (err) ->
    $scope.error = true

  $scope.loadingPlace = false

  $scope.change = ->
    if $scope.place == ''
      delete $scope.placeData
    else
      $http.get('/places?q=' + $scope.place + '&latitude=' + $scope.position.coords.latitude + '&longitude=' + $scope.position.coords.longitude).then (res) ->
        $scope.places = res.data.predictions

  $scope.selectPlace = (id, name) ->
    $scope.loadingPlace = true
    $scope.places = []
    $scope.place = name
    $http.get('/places/' + id).then (res) ->
      $scope.loadingPlace = false
      $scope.placeData = res.data.result

  $scope.calculate = ->
    ratio = ($scope.deaths/utilsService.distance($scope.position.coords.latitude, $scope.position.coords.longitude, $scope.placeData.geometry.location.lat, $scope.placeData.geometry.location.lng))*100
    if ratio < 1
      $scope.result = 1
    else if ratio < 5
      $scope.result = 2
    else
      $scope.result = 3

  $scope.retry = ->
    delete $scope.result

]