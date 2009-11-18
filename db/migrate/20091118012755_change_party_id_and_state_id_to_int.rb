class ChangePartyIdAndStateIdToInt < ActiveRecord::Migration
  def self.up
    remove_column :members, :party_id
    remove_column :members, :state_id
    
    add_column :members, :party_id, :integer
    add_column :members, :state_id, :integer
  end

  def self.down
    remove_column :members, :state_id
    remove_column :members, :party_id
    
    add_column :members, :party_id, :string
    add_column :members, :state_id, :string
  end
end
