class AddTwitterUserToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :twitter_user, :string
  end

  def self.down
    remove_column :members, :twitter_user
  end
end
