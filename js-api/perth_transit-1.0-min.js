// Perth Transit JS API
//
// Version:   1.0
// Requires:  jQuery
// License:   MIT
// Copyright: Darcy Laycock
(function(e,t){var n={version:1,root:"http://api.perthtransit.com/"},r=function(e){if(e===t)return null;var n=""+e.lat+","+e.lng;return{near:n}},i=function(e){var t=typeof e;return t==="number"||t==="string"?""+e:e.identifier};n.get=function(t,n){var r=this.urlFor(t,n),i=e.getJSON(r),s=function(e){return e.response},o=function(e){return e};return i.pipe(s,o)},n.urlFor=function(n,r){var i=this.root+this.version+"/"+n+"?callback=?";return r!==t&&(i=i+"&"+e.param(r)),i},n.trainStations=function(e){return this.get("train_stations",r(e))},n.trainStation=function(e){return this.get("train_stations/"+i(e))},n.busStops=function(e){return this.get("bus_stops",r(e))},n.busStop=function(e){return this.get("bus_stops/"+i(station))},n.smartRider=function(e){return this.get("smart_riders/"+e)},window.PerthTransit=n})(jQuery);