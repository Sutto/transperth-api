# Perth Transit API

The Perth Transit API is an unofficial, open source API to provide easy access to Transperth
data for developers. You can access the code [on GitHub](https://github.com/sutto/transperth-api).

The API is exposed at [http://api.perthtransit.com/](http://api.perthtransit.com/).

## API Conventions

As the API is built using [RocketPants](https://github.com/filtersquad/rocket_pants), the following conventions apply:

* Responses are under the `"response"` top level key, with arrays representing collections and objects representing
  specific objects.
* Metadata e.g. a count of objects in a collection are exposed under the top level.
* `near` is used with values in the form of `lat,lng` for geo-specific responses.
* Caching should be used and respected. Timeouts are chosen to ease the load on Transperth services
  and to ensure optimum responses.

## Caching

We use time-based expiration and etag-based validation. Please respect our HTTP caching
where possible. We cache on the server side to ease the load in this regard.

### Errors

Unlike normal responses, errors are exposed in the following format:

```json
{
  "error": "error_name",
  "error_description": "English text description of objects"
}
```

Where `error` is a symbolic name (e.g. `not_found` being the most common)
and `error_description` is a english description of what failed. Errors
also are accompanied by an equivalent HTTP status code - e.g. `404` for the not found example above.

### Compact Responses

The API uses the concept of compact objects - A version of an object with
a minimal set of information required to display it and to look up a full version.
In the API, these objects are marked with the attribute `"compact": true`.

Compact objects will have a URL attribute that points to the full expanded version of the object.

### URL Construction

Objects usually include a `"url"` pointing to the full object, but in cases where
they don't or you wish to construct URLs from the API client, the templates can also be
found from the root url of the API.

With the exception of smart riders, all objects include an `"identifier"` field, specifying
a unique value for the given object which can be used to replace the `:identifier` placeholder
in a URL.

## Notes

The API is currently implemented using scraping, but makes a best attempt to be efficient
and avoid processing data it doesn't have to. Likewise, it caches as much as needed to
prevent clients from returning multiple items.

Currently the API provides Geolocation based Train and Bus stop lookup, Live times
for trains and scheduled times for busses. As an added bonus, we include a time-delayed
wrapper for smart rider information.