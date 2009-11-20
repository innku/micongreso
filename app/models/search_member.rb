class SearchMember < ActiveRecord::Base
  
  def members
    @members ||= find_members
  end
  
  private
  
  def find_members
    Member.find(:all, :include => [:party, :state], :conditions => conditions)
  end
  
  def complete_conditions
    ["members.complete = ?", true]
  end
  
  def name_conditions
    ["members.name LIKE ?", "%#{name}%"] unless name.blank?
  end

  def party_conditions
    ["members.party_id = ?", party_id] unless party_id.blank?
  end
  
  def state_conditions
    ["members.state_id = ?", state_id] unless state_id.blank?
  end

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
end
