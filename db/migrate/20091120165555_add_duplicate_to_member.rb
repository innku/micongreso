class AddDuplicateToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :duplicate, :boolean, :default => false
  end

  def self.down
    remove_column :members, :duplicate
  end
end
