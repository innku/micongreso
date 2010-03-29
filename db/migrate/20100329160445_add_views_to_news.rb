class AddViewsToNews < ActiveRecord::Migration
  def self.up
    add_column :news, :views, :integer, :default => 0
  end

  def self.down
    remove_column :news, :views
  end
end
