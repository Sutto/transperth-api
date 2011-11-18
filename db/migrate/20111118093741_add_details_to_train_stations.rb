class AddDetailsToTrainStations < ActiveRecord::Migration
  def change
    add_column :train_stations, :lat, :decimal
    add_column :train_stations, :lng, :decimal
  end
end
