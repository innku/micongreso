class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  
  default_scope order('created_at ASC')
  
  validates_presence_of :title, :comment
end
