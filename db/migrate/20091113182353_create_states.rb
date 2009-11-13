class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string :name
      t.string :abbr
      t.string :short2
      t.string :short3
    end
  end
  
  def self.down
    drop_table :states
  end
end
