class AddSubdomainToState < ActiveRecord::Migration
  def self.up
    add_column :states, :subdomain, :string
  end

  def self.down
    remove_column :states, :subdomain
  end
end
