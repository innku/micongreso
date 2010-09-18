class ChangeToAuthenticationToAuthlogic < ActiveRecord::Migration
  def self.up
    change_column :users, :crypted_password, :string, :limit => 128
    change_column :users, :salt, :string, :limit => 128
  end

  def self.down
    change_column :users, :crypted_password, :string, :limit => 40
    change_column :users, :salt, :string, :limit => 40
  end
end
