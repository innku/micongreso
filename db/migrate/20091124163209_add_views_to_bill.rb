class AddViewsToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :total_views,:integer,   :default => 0
    add_column :bills, :week_views, :integer,   :default => 0
  end

  def self.down
    remove_column :bills, :week_views
    remove_column :bills, :total_views
  end
end
