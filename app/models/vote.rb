class Vote < ActiveRecord::Base
  
  after_create :update_votes_count
  after_destroy :update_votes_count
  
  def update_votes_count
    self.voteable.update_users_votes_count!(self.vote) if self.voteable.class == Bill
  end
end