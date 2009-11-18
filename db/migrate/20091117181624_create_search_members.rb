class CreateSearchMembers < ActiveRecord::Migration
  def self.up
    create_table :search_members do |t|
      t.string :name
      t.integer :party_id
      t.integer :state_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :search_members
  end
end
