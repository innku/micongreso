class ChangeBirthdateToDate < ActiveRecord::Migration
  def self.up
    change_column :members, :birthdate, :date
  end

  def self.down
    change_column :members, :birthdate, :datetime
  end
end
