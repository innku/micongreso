class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name
      t.string :email
      t.string :party_id
      t.string :commission
      t.string :state_id
      t.integer :district
      t.string :head
      t.string :election
      t.datetime :birthdate
      t.string :birthplace
      t.string :substitute
      t.timestamps
    end
  end
  
  def self.down
    drop_table :members
  end
end
