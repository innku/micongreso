class Party < ActiveRecord::Base
  
  has_many  :members
end
