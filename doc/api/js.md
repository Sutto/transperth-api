# The JS API

We provide a convienantly embeddable and hosted version of the JS api, served via S3.

The two core files for this are:

* http://js.perthtransit.com/perth_transit-1.0-min.js - The minified version of the API
* http://js.perthtransit.com/perth_transit-1.0.js - The raw source code.

We provide access to these JS files for free, but it's up to you if you wish to use our
hosted versions or download your own. They also serve as an example of a simple API client.

## Conventions

Each API call returns a jQuery promise and uses JSONP to get the data. This, for all calls,
the `.done()` callback will be provided the raw data (either a JS array or JS object), whilst
the `.fail()` callback will be provided with an error.

As an example:

```js
PerthTransit.trainStations().done(function(stations) {
  $.each(stations, function() {
    console.log("Station named", this.name)
  });
});
```

Would print all Train Station names.

## API Methods

The following API endpoints are supported:

* `PerthTransit.trainStations()` - Returns a list of all train stations in Perth.
* `PerthTransit.trainStations({lat: "123", lng: "345"})` - Returns up to 5 stations within a 2.5km radius of the given point, closest first.
* `PerthTransit.trainStation("armadale")` - Returns a train station object (including times) from a identifier.
* `PerthTransit.trainStation(armadale_station_object)` - From a train station object from the previous calls, returns the full object, including times.
* `PerthTransit.busStops({lat: "123", lng: "345"})` - Returns up to 5 bus stops within a 2.5km radius of the given point, closest first.
* `PerthTransit.busStop("12345")` - Returns a bus stop object (including times) from a stop number.
* `PerthTransit.busStop(stop_object)` - From a bus stop object from the previous calls, returns the full object, including times.
* `PerthTransit.smartRider("012345")` - Returns information for the given smartrider number.