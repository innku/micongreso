class AddVoteDateToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :vote_date, :date
  end

  def self.down
    remove_column :bills, :vote_date
  end
end
