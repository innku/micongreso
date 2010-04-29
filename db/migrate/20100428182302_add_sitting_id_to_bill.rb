class AddSittingIdToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :sitting_id, :integer
  end

  def self.down
    remove_column :bills, :sitting_id
  end
end
