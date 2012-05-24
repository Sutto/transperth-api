attribute :name, :lat, :lng, :cached_slug
node(:url) { |m| train_station_url(m) }
node(:compact) { true }