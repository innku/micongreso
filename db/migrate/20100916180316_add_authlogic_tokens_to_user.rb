class AddAuthlogicTokensToUser < ActiveRecord::Migration
  def self.up    
    remove_column :users, :remember_token
    remove_column :users, :remember_token_expires_at
    add_column :users, :persistence_token, :string
    add_column :users, :perishable_token, :string
    remove_column :users, :activated_at
    
    User.all.each {|u| u.save!}
  end

  def self.down
    add_column :users, :activated_at, :datetime
    remove_column :users, :perishable_token
    remove_column :users, :persistence_token
    add_column :users, :remember_token_expires_at, :datetime
    add_column :users, :remember_token, :string,            :limit => 40
  end
end
