class AddInvitedOnToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :invited_on, :datetime
  end

  def self.down
    remove_column :contacts, :invited_on
  end
end
