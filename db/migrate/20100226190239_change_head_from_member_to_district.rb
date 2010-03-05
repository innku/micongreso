class ChangeHeadFromMemberToDistrict < ActiveRecord::Migration
  def self.up
    remove_column :members, :head
    add_column :districts, :head, :string
  end

  def self.down
    remove_column :districts, :head
    add_column :members, :head, :string
  end
end
