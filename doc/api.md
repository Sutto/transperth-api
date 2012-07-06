# The Unofficial Transperth API

This application houses an unofficial API wrapping the Transperth Web Site.

It's currently implemented using scraping, but makes its best attempt to be efficient
at it and to avoid processing data it doesn't have to. Likewise, it caches as much
as needed to prevent clients from returning multiple items.

Currently the API providers Geolocation based Train and Bus stop lookup, Live times
for trains and scheduled times for busses. As an added bonus, we include a time-delayed
wrapper for smart rider information.

