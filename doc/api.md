# Perth Transit API

The perth transit is an unofficial API to provide easy access to Transperth
data for developers.

The API is exposed from [http://api.perthtransit.com/](http://api.perthtransit.com/).

Please note that this entire API is open source - You can access the code [on GitHub](https://github.com/sutto/transperth-api).

## API Conventions

### Errors

### Compact Responses

### URL Construction

## Notes

It's currently implemented using scraping, but makes its best attempt to be efficient
at it and to avoid processing data it doesn't have to. Likewise, it caches as much
as needed to prevent clients from returning multiple items.

Currently the API providers Geolocation based Train and Bus stop lookup, Live times
for trains and scheduled times for busses. As an added bonus, we include a time-delayed
wrapper for smart rider information.

