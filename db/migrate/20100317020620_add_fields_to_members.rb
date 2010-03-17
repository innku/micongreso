class AddFieldsToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :curul, :string
    add_column :members, :education, :text
    add_column :members, :political_experience, :text
    add_column :members, :private_experience, :text
  end

  def self.down
    remove_column :members, :private_experience
    remove_column :members, :political_experience
    remove_column :members, :education
    remove_column :members, :curul
  end
end
