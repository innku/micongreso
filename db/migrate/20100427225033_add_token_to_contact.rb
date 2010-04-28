class AddTokenToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :token, :string
  end

  def self.down
    remove_column :contacts, :token
  end
end
