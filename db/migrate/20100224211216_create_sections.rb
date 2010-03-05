class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.integer :number,      :null => false
      t.integer :district_id, :null => false
    end
  end
  
  def self.down
    drop_table :sections
  end
end
