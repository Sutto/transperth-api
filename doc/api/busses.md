# Bus Times

## Getting stops near a given location

To get a list of bus stops near a given location, you need to
hit the `/1/bus_stops` location with a `near` paramter specifying
formatted `lat,lng` pair.

Note you can optionally override the default distance by passing in a kilometres
value in the `distance` parameter. Note that a `bad_request` error will be returned
with a value that is not a number and that your values will be boxed to a minimum
of 250m and a maximum of 50km. There is also a limit of 5 that still applies.

This will return the five closest bus stops within 2.5km of the specified coordinate.

```http
GET /1/bus_stops?near=-32.1366,116.0176 HTTP/1.1
```

```http
HTTP/1.1 200 OK
Cache-Control: max-age=180, public, must-revalidate
Content-Type: application/json; charset=utf-8

{
  "count": 5,
  "response": [{
    "compact": true,
    "description": null,
    "name": "Albany Hwy After Galliers Av",
    "lat": "-32.1365533333333",
    "lng": "116.017569444444",
    "stop_number": "10004",
    "identifier": "10004"
  }, {
    "compact": true,
    "description": null,
    "name": "Albany Hwy Before Carawatha Av",
    "lat": "-32.1359372222222",
    "lng": "116.017875",
    "stop_number": "10205",
    "identifier": "10205"
  }, {
    "compact": true,
    "description": null,
    "name": "Albany Hwy Before Caroline St",
    "lat": "-32.1376488888889",
    "lng": "116.017727777778",
    "stop_number": "10206",
    "identifier": "10206"
  }, {
    "compact": true,
    "description": null,
    "name": "Albany Hwy After Rogers L",
    "lat": "-32.1391138888889",
    "lng": "116.017382222222",
    "stop_number": "10003",
    "identifier": "10003"
  }, {
    "compact": true,
    "description": null,
    "name": "Albany Hwy After Caroline St",
    "lat": "-32.1394066666667",
    "lng": "116.01758",
    "stop_number": "10207",
    "identifier": "10207"
  }]
}
```

## Getting busses for a specific stop

Finally, from a specific bus stop, you can get a list of times for the given bus stop.

Please note that these are only scheduled times and do not necessarily reflect the busses current status.

```http
GET /1/bus_stops/12331 HTTP/1.1
```

```http
HTTP/1.1 200 OK
Cache-Control: max-age=180, public, must-revalidate
Content-Type: application/json; charset=utf-8

{
  "response": {
    "description": "Wanneroo Rd / Beach Rd",
    "name": "Wanneroo Rd After Beach Rd",
    "lat": "-31.8436127777778",
    "lng": "115.823664444444",
    "stop_number": "12331",
    "times": [{
      "approximate": false,
      "comment": null,
      "destination": "To Wellington St Bus Stn",
      "route": "388",
      "time": "19:35"
    }, {
      "approximate": true,
      "comment": null,
      "destination": "To Morley Bus Stn",
      "route": "371",
      "time": "19:41"
    }]
  }
}
```