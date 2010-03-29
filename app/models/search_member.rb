class SearchMember < ActiveRecord::Base
  
  def conditions
    conditions = {:name_like => self.name}
    conditions[:party_id_is] = self.party_id if self.party_id
    conditions[:state_id_is] = self.state_id if self.state_id
    
    return conditions
  end
end
