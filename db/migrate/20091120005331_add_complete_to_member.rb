class AddCompleteToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :complete, :boolean, :default => true
  end

  def self.down
    remove_column :members, :complete
  end
end
