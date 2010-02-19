class State < ActiveRecord::Base
  
  has_many :members
  
  def id_as_string
    id.to_s
  end
  
  def self.google_codes_and_votes(bill)
    codes_array = []
    all.each do |state|
      codes_array << "['MX-#{state.short3}', '#{state.name}', #{bill.citizen_votes_for_state(state, true)}]"
    end
    codes_array.join(',')
  end
end
