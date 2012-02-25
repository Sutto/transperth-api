class CreateBusStops < ActiveRecord::Migration
  def change
    create_table :bus_stops do |t|
      t.string :display_name
      t.string :stop_number
      t.integer :gtfs_id
      t.decimal :lat
      t.decimal :lng
      t.string :description
      t.string :cached_slug
      t.timestamps
    end
    add_index :bus_stops, :cached_slug
  end
end
