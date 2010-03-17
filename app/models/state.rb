class State < ActiveRecord::Base
  
  has_many :members
  has_many :districts
  has_many :cities
  
  belongs_to  :region
  
  has_many :sections, :through => :districts
  
  def id_as_string
    id.to_s
  end
  
  def self.google_codes_and_votes(bill)
    codes_array = []
    all.each do |state|
      voted_for = bill.citizen_votes_for_state(state, true)
      voted_against = bill.citizen_votes_for_state(state, false)
      voted_neutral = bill.citizen_votes_for_state(state, nil)
      total = voted_against+voted_neutral+voted_for
      if total == 0
        rate = 0
      else
        rate = (voted_for.to_f/total.to_f)*100.00
        RAILS_DEFAULT_LOGGER.debug "for: #{voted_for}, against: #{voted_against}, neutral: #{voted_neutral}, total: #{total}, rate #{rate}"
      end
      codes_array << "['MX-#{state.short3}', '#{state.name}', #{rate}, #{voted_for}, #{voted_against}, #{voted_neutral}]"
    end
    codes_array.join(',')
  end
end
