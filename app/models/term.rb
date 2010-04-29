class Term < ActiveRecord::Base
  
  has_many  :sittings,  :dependent => :nullify
  has_many  :members,   :dependent => :nullify
end
