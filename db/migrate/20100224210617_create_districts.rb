class CreateDistricts < ActiveRecord::Migration
  def self.up
    create_table :districts do |t|
      t.integer :number,    :null => false
      t.integer :state_id,  :null => false
    end
  end
  
  def self.down
    drop_table :districts
  end
end
