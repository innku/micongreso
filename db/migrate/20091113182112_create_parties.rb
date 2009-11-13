class CreateParties < ActiveRecord::Migration
  def self.up
    create_table :parties do |t|
      t.string :name
      t.string :abbr
    end
  end
  
  def self.down
    drop_table :parties
  end
end
