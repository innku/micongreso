class District < ActiveRecord::Base
  
  belongs_to  :state
  has_many    :sections
  has_one     :member
  
  delegate :region, :to => :state
end
