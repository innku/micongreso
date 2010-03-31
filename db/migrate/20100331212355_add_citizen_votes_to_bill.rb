class AddCitizenVotesToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :user_votes_for, :integer,     :default => 0
    add_column :bills, :user_votes_against, :integer, :default => 0
    add_column :bills, :user_votes_neutral, :integer, :default => 0
    
    Bill.all.each do |bill|
      bill.user_votes_for = bill.citizen_votes(true)
      bill.user_votes_against = bill.citizen_votes(false)
      bill.user_votes_neutral = bill.citizen_votes(nil)
      bill.save!
    end
  end

  def self.down
    remove_column :bills, :user_votes_neutral
    remove_column :bills, :user_votes_against
    remove_column :bills, :user_votes_for
  end
end
