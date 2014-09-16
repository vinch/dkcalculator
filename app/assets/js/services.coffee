dkCalculatorAppServices = angular.module 'dkCalculatorAppServices', []

dkCalculatorAppServices.factory 'geolocationService', ['$q', '$window', '$rootScope', ($q, $window, $rootScope) ->
  return ->
    deferred = $q.defer()
    unless 'geolocation' of $window.navigator
      deferred.reject 'Geolocation is not supported'
    else
      $window.navigator.geolocation.getCurrentPosition ((position) ->
        $rootScope.$apply ->
          deferred.resolve position
      ), (err) ->
        deferred.reject err.message

    return deferred.promise
]

dkCalculatorAppServices.factory 'utilsService', ->
  return {
    deg2rad: (deg) ->
      return deg * (Math.PI/180)
    distance: (lat1, lon1, lat2, lon2) ->
      R = 3961
      dLat = @deg2rad(lat2-lat1)
      dLon = @deg2rad(lon2-lon1) 
      a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(@deg2rad(lat1)) * Math.cos(@deg2rad(lat2)) * Math.sin(dLon/2) * Math.sin(dLon/2)
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)) 
      d = R * c
      return d

  }