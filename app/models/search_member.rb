class SearchMember < ActiveRecord::Base
  
  def members
    @results = start_search
    @results &= search_name unless name.blank?
    @results &= search_party unless party_id.blank?
    @results &= search_state unless state_id.blank?
    @results
  end
  
  def start_search
    Member.includes(:state, :district, :party)
  end
  
  def search_name
    Member.where("name #{$like} ?", "%#{self.name}%")
  end
  
  def search_party
    Member.where(:party_id => self.party_id)
  end
  
  def search_state
    Member.where(:state_id => self.state_id)
  end
end
