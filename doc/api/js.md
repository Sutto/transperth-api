# The JS API

We provide a convienantly embeddable and hosted version of the JS api, served via S3.

The two core files for this are:

* http://js.perthtransit.com/perth_transit-1.0-min.js - The minified version of the API
* http://js.perthtransit.com/perth_transit-1.0.js - The raw source code.

We provide access to these JS files for free, but it's up to you if you wish to use our
hosted versions or download your own. They also serve as an example of a simple API client.

## Conventions

Each API call returns a jQuery deferred and uses JSONP to get the data. This, for all calls,
the `.done()` callback will be provided the raw data (either a JS array or JS object), whilst
the `.fail()` callback will be provided with an error.

As an example:

```js
PerthTransit.trainStations().done(function(stations) {
  $.each(stations, function() {
    console.log("Station:", this.name)
  });
});
```

Would print all Train Station names.

### Getting Specific Objects

Functions returning a single item accept either the `identifier` property from the object (e.g. `"armadale"` for a train station)
or an instance of the object - The general process is to take the object returned from the list, and use the specific instance
to get an expanded version including times.

### Geolocated Data

Functions that allow a location filter (`PerthTransit.trainStations` and `PerthTransit.busStops`), both accept objects in any one of the following
forms:

* `{"lat": 123, "lng": 456}`
* `{"lat": 123, "lon": 456}`
* `{"latitude": 123, "longitude": 456}`

Or any object including those properties. Note that this means it works with the coords object from the browsers built in
Geolocation APIs.

## Nearby Stops and Stations

The two simplest and most useful forms of the api, these use the [JavaScript Geolocation API](http://dev.w3.org/geo/api/spec-source.html) to
attempt to load upto 5 of the closest train stations or bus stops (within a 2.5km distance).

### Nearby Train Stations

`PerthTransit.nearbyTrainStations` returns a deferred that is resolved when it recieves the train locations back. Note that the API doesn't currently
trigger the fail / reject portion of the deferred when access is denied but this may be added.

The response data will be a list of up to 5 compact train station objects.

```js
PerthTransit.nearbyTrainStations().done(function(stations) {
  $.each(stations, function() {
    console.log("Station:", this.name)
  });
});
```

### Nearby Bus Stops

`PerthTransit.nearbyBusStops` returns a deferred that is resolved when it recieves the bus stop locations back. Note that the API doesn't currently
trigger the fail / reject portion of the deferred when access is denied but this may be added.

The response data will be a list of up to 5 compact bus stop objects.

```js
PerthTransit.nearbyBusStops().done(function(stops) {
  $.each(stops, function() {
    console.log("Bus Stop:", this.display_name)
  });
});
```

## Train Stations

### Getting all Train Stations

To get a list of all train stations in perth, simply use `PerthTransit.trainStations`.

```js
PerthTransit.trainStations().done(function(stations) {
  $.each(stations, function() {
    console.log("Station:", this.name)
  });
});
```

### Getting Train Stations near a specific point

By providing a location object (discussed above), you can easily filter to stops near a given location:

```js
PerthTransit.trainStations({lat: -32.1376, lng: 116.0104}).done(function(stations) {
  $.each(stations, function() {
    console.log("Station:", this.name)
  });
});
```

### Getting a specific Train Station

Using either an instance from the prior functions or a train station identifier, you can also get the full train station object, including live times:

```js
PerthTransit.trainStation("daglish").done(function(station) {
  console.log(station.name, station.times);
});
```

Or, using the object from the collection functions:

```js
PerthTransit.trainStation(daglishStation).done(function(station) {
  console.log(station.name, station.times);
});
```

## Bus Stops

### Getting a Bus Stop near a specific point

The bus stop api only provides access to those restricted by a location. To access them, use the
`PerthTransit.busStops` function and provide a location object:

```js
PerthTransit.busStops({lat: -32.1376, lng: 116.0104}).done(function(stops) {
  $.each(stops, function() {
    console.log("Bus Stop:", this.display_name)
  });
});
```

### Getting a specific Bus Stop

Using either an instance from the prior functions or a stop identifier / number, you can also get the full bus stop object, including times:

```js
PerthTransit.busStop("22064").done(function(stop) {
  console.log(stop.display_name, stop.times);
});
```

Or, using the object from the collection functions:

```js
PerthTransit.busStop(stopNearMyHouse).done(function(stop) {
  console.log(stop.display_name, stop.times);
});
```
