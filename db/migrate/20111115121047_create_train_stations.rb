class CreateTrainStations < ActiveRecord::Migration
  def change
    create_table :train_stations do |t|
      t.string :name

      t.timestamps
    end
  end
end
