class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.integer :number,  :null => false
    end
    
    add_column :states, :region_id, :integer
  end
  
  def self.down
    remove_column :states, :region_id
    drop_table :regions
  end
end
