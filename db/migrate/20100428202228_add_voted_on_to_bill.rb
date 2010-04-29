class AddVotedOnToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :voted_on, :datetime, :default => nil
  end

  def self.down
    remove_column :bills, :voted_on
  end
end
