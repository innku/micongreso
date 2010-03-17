class City < ActiveRecord::Base
  
  belongs_to  :state
  
  named_scope :with_name, lambda {|name| {:conditions => ["cities.name = '#{name}' or cities.city_name = '#{name}'"]} }
  named_scope :like, lambda {|name| { :include => [:state], :conditions => ["cities.name LIKE '%%#{name}%%' OR cities.city_name LIKE '%%#{name}%%'"]} }
  named_scope :with_state_name, lambda {|state_name| {:include => [:state], :conditions => ["states.name = '#{state_name}' or states.abbr = '#{state_name}' or states.short2='#{state_name}' or states.short3='#{state_name}'"]} }
	
	def self.find_by_full_name(full_name)
    unless full_name.blank?
      city_name, state_name = full_name.split(",")
      @cities = City.like(city_name.strip)
      @cities = @cities.with_state_name(state_name.strip) if state_name
      @cities
    else
      []
    end
  end
  
  def full_name
    self.name + ", " + self.state.name
  end
end
