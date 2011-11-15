Transperth::Application.routes.draw do
  api :version => 1 do
    get 'train_stations', :to => 'train_stations#index'
  end
end