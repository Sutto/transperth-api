class TrainStation < ActiveRecord::Base
  validates_presence_of :name

  def self.seed!
    destroy_all
    TransperthClient.train_stations.each do |name|
      create :name => name
    end
  end

end
