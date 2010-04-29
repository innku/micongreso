class AddTermIdToSittingsAndMembers < ActiveRecord::Migration
  def self.up
    add_column :sittings, :term_id, :integer
    add_column :members, :term_id, :integer
  end

  def self.down
    remove_column :sittings, :term_id
    remove_column :members, :term_id
  end
end
