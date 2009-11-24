class Bill < ActiveRecord::Base
  
  validates_presence_of :name, :message => "^Te faltó el título de la propuesta"
  validates_presence_of :description, :message => "^Te faltó la descripción de la propuesta"
  
  acts_as_taggable
  acts_as_voteable
  
  def formatted_date
    if self.new_record?
      Date.today.to_s(:es)
    else
      read_attribute(:date).to_s(:es)
    end
  end
  
  def formatted_date=(date)
  end
  
  def votes_for_for_party(party)
    Vote.count(:all, :joins => "INNER JOIN members ON members.id = votes.voter_id",
                      :conditions => ["voteable_id = ? AND voteable_type = ? AND vote = ? AND voter_type = ? AND members.party_id = ?", self.id, self.class.name, true, "Member", party.id])
  end
  
  def votes_against_for_party(party)
    Vote.count(:all, :joins => "INNER JOIN members ON members.id = votes.voter_id",
                      :conditions => ["voteable_id = ? AND voteable_type = ? AND vote = ? AND voter_type = ? AND members.party_id = ?", self.id, self.class.name, false, "Member", party.id])
  end
  
  def votes_neutral_for_party(party)
    Vote.count(:all, :joins => "INNER JOIN members ON members.id = votes.voter_id",
                      :conditions => ["voteable_id = ? AND voteable_type = ? AND vote IS NULL AND voter_type = ? AND members.party_id = ?", self.id, self.class.name, "Member", party.id])
  end
  
  def votes_for_for_state(state)
    Vote.count(:all, :joins => "INNER JOIN members ON members.id = votes.voter_id",
                      :conditions => ["voteable_id = ? AND voteable_type = ? AND vote = ? AND voter_type = ? AND members.state_id = ?", self.id, self.class.name, true, "Member", state.id])
  end
  
  def votes_against_for_state(state)
    Vote.count(:all, :joins => "INNER JOIN members ON members.id = votes.voter_id",
                      :conditions => ["voteable_id = ? AND voteable_type = ? AND vote = ? AND voter_type = ? AND members.state_id = ?", self.id, self.class.name, false, "Member", state.id])
  end
  
  def votes_neutral_for_state(state)
    Vote.count(:all, :joins => "INNER JOIN members ON members.id = votes.voter_id",
                      :conditions => ["voteable_id = ? AND voteable_type = ? AND vote IS NULL AND voter_type = ? AND members.state_id = ?", self.id, self.class.name, "Member", state.id])
  end
end
