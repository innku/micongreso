class AddCongressIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :congress_id, :integer
  end

  def self.down
    remove_column :users, :congress_id
  end
end
