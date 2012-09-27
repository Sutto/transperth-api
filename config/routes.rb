Transperth::Application.routes.draw do
  api version: 1 do
    get 'train_stations',     :to => 'train_stations#index', :as => :train_stations
    get 'train_stations/:id', :to => 'train_stations#show',  :as => :train_station
    get 'bus_stops/:id',      :to => 'bus_stops#show',       :as => :bus_stop
    get 'bus_stops',          :to => 'bus_stops#index',      :as => :bus_stops
    get 'smart_riders/:id',   :to => 'smart_riders#show',    :as => :smart_rider
  end
  root to: 'site#index'
end