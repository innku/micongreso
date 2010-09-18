class City < ActiveRecord::Base
  
  belongs_to  :state
    	
	def self.with_name(name)
	  where("cities.name = '#{name}' OR cities.city_name = '#{name}'")
	end
	
	def self.like
	  where("cities.name #{$like} '%%#{name}%%' OR cities.city_name #{$like} '%%#{name}%%'").includes(:state)
	end
	
	def self.with_state_name
	  where("states.name = '#{state_name}' or states.abbr = '#{state_name}' or states.short2='#{state_name}' or states.short3='#{state_name}'").includes(:state)
	end
	
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
