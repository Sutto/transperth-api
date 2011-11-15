Transperth::Application.routes.draw do
  api :version => 1 do
    get 'train_stations',     :to => 'train_stations#index'
    get 'train_stations/:id', :to => 'train_stations#show'
  end
end