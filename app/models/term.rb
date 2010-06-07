class Term < ActiveRecord::Base
  
  has_many  :sittings,  :dependent => :nullify
  has_many  :members,   :dependent => :nullify
  
  belongs_to  :congress, :class_name => "State"
end
