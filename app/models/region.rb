class Region < ActiveRecord::Base
  
  has_many  :states
  has_many  :members, :through => :states
  has_many  :representatives, :through => :states, :source => :members, :conditions => "members.election = 'Representación Proporcional'"
end
