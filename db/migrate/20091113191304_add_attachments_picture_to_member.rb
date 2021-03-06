class AddAttachmentsPictureToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :picture_file_name, :string
    add_column :members, :picture_content_type, :string
    add_column :members, :picture_file_size, :integer,    :default => 0
    add_column :members, :picture_updated_at, :datetime
  end

  def self.down
    remove_column :members, :picture_file_name
    remove_column :members, :picture_content_type
    remove_column :members, :picture_file_size
    remove_column :members, :picture_updated_at
  end
end
