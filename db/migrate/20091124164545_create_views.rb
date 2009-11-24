class CreateViews < ActiveRecord::Migration
  def self.up
    create_table :views do |t|
      t.integer :bill_id
      t.timestamps
    end
    
    add_index :views, :bill_id
  end
  
  def self.down
    drop_table :views
  end
end
