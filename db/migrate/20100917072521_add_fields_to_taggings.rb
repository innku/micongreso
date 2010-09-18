class AddFieldsToTaggings < ActiveRecord::Migration
  def self.up
    add_column :taggings, :tagger_id, :string
    add_column :taggings, :tagger_type, :string
    add_column :taggings, :context, :string
    
    ActsAsTaggableOn::Tagging.all.each {|t| t.context = "tags"; t.save!}
  end

  def self.down
    remove_column :taggings, :context
    remove_column :taggings, :tagger_type
    remove_column :taggings, :tagger_id
  end
end
