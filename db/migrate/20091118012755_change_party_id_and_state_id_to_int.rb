class ChangePartyIdAndStateIdToInt < ActiveRecord::Migration
  def self.up
    change_column :members, :party_id, :integer
    change_column :members, :state_id, :integer
  end

  def self.down
    change_column :members, :state_id, :string
    change_column :members, :party_id, :string
  end
end
