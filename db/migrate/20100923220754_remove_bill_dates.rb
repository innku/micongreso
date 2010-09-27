class RemoveBillDates < ActiveRecord::Migration
  def self.up
    remove_column :bills, :date
    remove_column :bills, :vote_date
    remove_column :bills, :voted_on
  end

  def self.down
    add_column :bills, :voted_on, :datetime
    add_column :bills, :vote_date, :date
    add_column :bills, :date, :date
  end
end
