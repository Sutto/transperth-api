# Train Times & Stops

The core of Perth Transit is the access we provide to train data.

Namely, Unlike the GTFS data feeds Perth Transit provides Live Train
times from the Transperth Website, including extra data such as the number
of cars.

**Please Note:** The examples below use shortened data to make it easier to read.

## Finding Train Stations

The core endpoint is a list of all trainstations that are available.

This endpoint is available under `/1/train_stations`. As an example:

```http
GET /1/train_stations HTTP/1.1
```

```http
HTTP/1.1 200 OK
Cache-Control: max-age=86400, public, must-revalidate
Content-Type: application/json; charset=utf-8

{
  "count": 69,
  "response": [{
    "identifier": "armadale",
    "compact": true,
    "lat": "-32.1376083",
    "lng": "116.0104606",
    "name": "Armadale",
    "url": "http://api.perthtransit.com/1/train_stations/armadale"
  }, {
    "identifier": "ashfield",
    "compact": true,
    "lat": "-31.9129489",
    "lng": "115.9359944",
    "name": "Ashfield",
    "url": "http://api.perthtransit.com/1/train_stations/ashfield"
  }, {
    "identifier": "bassendean",
    "compact": true,
    "lat": "-31.9037106",
    "lng": "115.94718",
    "name": "Bassendean",
    "url": "http://api.perthtransit.com/1/train_stations/bassendean"
  }]
}
```

## Nearby Train Stations

By providing a `near` parameter with a formatted `lat,lng` pair, you can filter
to only stations within a 2.5 kilometre distance from the specified location up
to a limit of 5.

Note you can optionally override the default distance by passing in a kilometres
value in the `distance` parameter. Note that a `bad_request` error will be returned
with a value that is not a number and that your values will be boxed to a minimum
of 250m and a maximum of 50km. There is also a limit of 5 that still applies.

For example,

```http
GET /1/train_stations?near=-32.1376,116.0104 HTTP/1.1
```

```http
HTTP/1.1 200 OK
Cache-Control: max-age=86400, public, must-revalidate
Content-Type: application/json; charset=utf-8

{
  "count": 3,
  "response": [{
    "identifier": "armadale",
    "compact": true,
    "lat": "-32.1376083",
    "lng": "116.0104606",
    "name": "Armadale",
    "url": "http://api.perthtransit.com/1/train_stations/armadale"
  }, {
    "identifier": "sherwood",
    "compact": true,
    "lat": "-32.1376083",
    "lng": "116.0104606",
    "name": "Sherwood",
    "url": "http://api.perthtransit.com/1/train_stations/sherwood"
  }, {
    "identifier": "challis",
    "compact": true,
    "lat": "-32.1263406",
    "lng": "116.0129372",
    "name": "Challis",
    "url": "http://api.perthtransit.com/1/train_stations/challis"
  }]
}
```

## Getting live times for a given train station

Finally, from a given train station, (using the URL or constructing a URL via the `cached_slug` field),
you can get the time information for a given station.

If the train station doesn't exist, it will instead return a 404
status code with `not_found` in the standard error body form.

```http
GET /1/train_stations/perth HTTP/1.1
```

```http
HTTP/1.1 200 OK
Cache-Control: max-age=60, public, must-revalidate
Content-Type: application/json; charset=utf-8
Etag: "example-etag-goes-here"

{
  "response": {
    "identifier": "perth",
    "compact": false,
    "lat": "-31.9510908",
    "lng": "115.8599254",
    "name": "Perth",
    "times": [{
      "cars": 4,
      "line": "Midland",
      "on_time": true,
      "pattern": null,
      "platform": 7,
      "status": "On Time",
      "time": "19:00"
    }, {
      "cars": 2,
      "line": "Fremantle",
      "on_time": true,
      "pattern": "K",
      "platform": 5,
      "status": "On Time",
      "time": "19:02"
    }, {
      "cars": 4,
      "line": "Armadale",
      "on_time": true,
      "pattern": "C",
      "platform": 6,
      "status": "On Time",
      "time": "19:02"
    }]
  }
}
```