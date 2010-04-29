class AddMemberIdToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :member_id, :integer
  end

  def self.down
    remove_column :bills, :member_id
  end
end
