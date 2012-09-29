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
    if(location === undefined) {
      return null;
    } else {
      var near = "" + location.lat + "," + location.lng;
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

  PerthTransit.get = function(path, options) {
    var url = this.urlFor(path, options);
    var promise = $.getJSON(url)
    var done   = function(data) { return data.response; };
    var failed = function(data) { return data; };
    return promise.pipe(done, failed);
  };

  PerthTransit.urlFor = function(path, options) {
    var fullURL = this.root + this.version + "/" + path + "?callback=?";
    if(options !== undefined) {
      fullURL = fullURL + "&" + $.param(options);
    }
    return fullURL;
  }

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
    return this.get('bus_stops/' + extractIdentifier(station));
  };

  PerthTransit.smartRider = function(smartRiderNumber) {
    return this.get('smart_riders/' + smartRiderNumber);
  };

  // Run free my child.
  window['PerthTransit'] = PerthTransit;

})(jQuery);