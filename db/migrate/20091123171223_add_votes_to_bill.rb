class AddVotesToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :member_votes_for, :integer,      :default => 0
    add_column :bills, :member_votes_against, :integer,  :default => 0
    add_column :bills, :member_votes_neutral, :integer,  :default => 0
  end

  def self.down
    remove_column :bills, :member_votes_neutral
    remove_column :bills, :member_votes_against
    remove_column :bills, :member_votes_for
  end
end
