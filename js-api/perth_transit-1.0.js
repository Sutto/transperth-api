// Perth Transit JS API
//
// Version:   1.0
// Requires:  jQuery
// License:   MIT
// Copyright: Darcy Laycock

(function($, undefined) {

  var PerthTransit = {
    version: 1,
    root:    "http://api.perthtransit.com/",
  };

  var dataWithLocation = function(location) {
    if(!location) {
      return null;
    } else {
      var lat = location.lat || location.latitude;
      var lng = location.lng || location.lon || location.longitude;
      var near = "" + lat + "," + lng;
      return {"near": near};
    }
  };

  var extractIdentifier = function(object) {
    var type = typeof object;
    if(type === "number" || type === "string") {
      return "" + object;
    } else {
      return object.identifier;
    }
  }

  var locationDeferred = function(invoker) {
    var deferred = $.Deferred();
    var positionCallback = function(position) {
      var newDeferred = invoker(position.coords);
      newDeferred.then(deferred.resolve, deferred.reject);
    };
    navigator.geolocation.getCurrentPosition(positionCallback, null, {maximumAge:600000});
    return deferred;
  }

  PerthTransit.get = function(path, options) {
    var url = this.urlFor(path, options);
    var deferred = $.getJSON(url);
    var done   = function(data) { return data.response; };
    var failed = function(data) { return data; };
    return deferred.pipe(done, failed);
  };

  PerthTransit.urlFor = function(path, options) {
    var fullURL = this.root + this.version + "/" + path + "?callback=?";
    // We include the params if specified.
    if(options) fullURL = fullURL + "&" + $.param(options);
    return fullURL;
  }

  PerthTransit.nearbyTrainStations = function() {
    return locationDeferred(function(location) { return PerthTransit.trainStations(location); });
  };

  PerthTransit.nearbyBusStops = function() {
    return locationDeferred(function(location) { return PerthTransit.busStops(location); });
  };

  PerthTransit.trainStations = function(location) {
    return this.get('train_stations', dataWithLocation(location));
  };

  PerthTransit.trainStation = function(station) {
    return this.get('train_stations/' + extractIdentifier(station));
  };

  PerthTransit.busStops = function(location) {
    return this.get('bus_stops', dataWithLocation(location));
  };

  PerthTransit.busStop = function(stop) {
    return this.get('bus_stops/' + extractIdentifier(stop));
  };

  PerthTransit.smartRider = function(smartRiderNumber) {
    return this.get('smart_riders/' + smartRiderNumber);
  };

  // Run free my child.
  window['PerthTransit'] = PerthTransit;

})(jQuery);