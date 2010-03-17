class AddOfficialIdToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :official_id, :integer
  end

  def self.down
    remove_column :members, :official_id
  end
end
