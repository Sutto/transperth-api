Transperth::Application.routes.draw do
  api :version => 1 do
    get 'train_stations',     :to => 'train_stations#index'
    get 'train_stations/:id', :to => 'train_stations#show', :as => :train_station
    get 'bus_stops/:id',      :to => 'bus_stops#show',      :as => :bus_stop
    get 'smart_riders/:id',   :to => 'smart_riders#show',   :as => :smart_rider
  end
end