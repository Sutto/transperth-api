class AddCachedSlugToTrainStations < ActiveRecord::Migration
  
  def self.up
    add_column :train_stations, :cached_slug, :string
    add_index  :train_stations, :cached_slug
  end

  def self.down
    remove_column :train_stations, :cached_slug
  end
  
end
