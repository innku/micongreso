class AddStateIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :state_id, :integer
  end

  def self.down
    remove_column :users, :state_id
  end
end
