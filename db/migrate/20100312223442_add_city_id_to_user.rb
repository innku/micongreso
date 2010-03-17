class AddCityIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :city_id, :integer
    remove_column :users, :api_key
    add_column :users, :section_id, :integer
    rename_column :users, :state_id, :ife_state_id
  end

  def self.down
    rename_column :users, :ife_state_id, :state_id
    remove_column :users, :section_id
    add_column :users, :api_key, :string
    remove_column :users, :city_id
  end
end
