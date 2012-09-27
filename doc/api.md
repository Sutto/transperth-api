# Perth Transit API

The perth transit is an unofficial API to provide easy access to Transperth
data for developers.

The API is exposed from [http://api.perthtransit.com/](http://api.perthtransit.com/).

Please note that this entire API is open source - You can access the code [on GitHub](https://github.com/sutto/transperth-api).

## API Conventions

Since the api is built on [RocketPants](https://github.com/filtersquad/rocket_pants), the following apply:

* Responses are under the `"response"` top level key, with arrays representing collections and objects representing
  specific objects.
* Metadata e.g. a count of objects in a collection are exposed under the top level.
* `near` is used with values in the form of `lat,lng` for geo-specific responses.
* Caching should be used and respected. Timeouts are chosen to ease the load on Transperth services
  and to ensure optimum responses.

## Caching

We use time-based expiration and etag-based validation. Namely, please respect our HTTP catching
where possible. Also, we do cache on the server side to ease the load in this regard.

### Errors

Unlike normal responses, errors are exposed in the form of:

```json
{
  "error": "error_name",
  "error_description": "English text description of objects"
}
```

Where `error_name` is a symbolic name (e.g. `not_found` being the most common)
and `error_description` is a english description of what failed. Note that errors
also are accompanied by a HTTP status code - e.g. `404` for the not found example above.

### Compact Responses

The API involves the concept of compact objects - Namely, a version
of an object with a minimal set of information required to display it
and to look up a full version. In the api, these are marked by objects
with `"compact": true` as an attribute on it.

By using the URL (endpoints are available from the root URL, e.g: http://api.perthtransit.com/)
you can get the full expanded version. By default, compact versions are lacking
extra details and things such as times.

### URL Construction

With the exception of smart riders, object by default include an `"identifier"` field, specifying
a value which is unique to the given object and can be interpolated into a URL.

By default, objects usually include a `"url"` pointing to the full object, but in cases where
they don't or you wish to construct urls from the API client, the templates can also be
found from the root url of the api. Simply replace the `:identifier` placeholder with the
identifier attribute from an object to expand on it.

## Notes

It's currently implemented using scraping, but makes its best attempt to be efficient
at it and to avoid processing data it doesn't have to. Likewise, it caches as much
as needed to prevent clients from returning multiple items.

Currently the API providers Geolocation based Train and Bus stop lookup, Live times
for trains and scheduled times for busses. As an added bonus, we include a time-delayed
wrapper for smart rider information.

