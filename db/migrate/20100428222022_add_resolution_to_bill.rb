class AddResolutionToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :resolution, :text
  end

  def self.down
    remove_column :bills, :resolution
  end
end
