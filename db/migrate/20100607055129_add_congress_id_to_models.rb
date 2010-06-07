class AddCongressIdToModels < ActiveRecord::Migration
  def self.up
    add_column :bills, :congress_id, :integer
    add_column :members, :congress_id, :integer
    add_column :news, :congress_id, :integer
    add_column :terms, :congress_id, :integer
  end

  def self.down
    remove_column :terms, :congress_id
    remove_column :news, :congress_id
    remove_column :members, :congress_id
    remove_column :bills, :congress_id
  end
end
