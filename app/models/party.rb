class Party < ActiveRecord::Base
  
  has_many  :members
  
  def id_as_string
    id.to_s
  end
  
  def self.votes_per_party(bill)
    parties_array = []
    all.each do |party|
      parties_array << "['#{party.abbr}',#{bill.votes_for_party(party, true)},#{bill.votes_for_party(party, false)},#{bill.votes_for_party(party, nil)}]"
    end
    parties_array.join(',')
  end
  
end
