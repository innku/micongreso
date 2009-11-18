class State < ActiveRecord::Base
  
  has_many :members
  
  def id_as_string
    id.to_s
  end
end
