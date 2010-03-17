class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string  :name
      t.integer :state_id
      t.string  :city_name
      t.integer :priority
    end
  end
  
  def self.down
    drop_table :cities
  end
end
