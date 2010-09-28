class Resource < ActiveRecord::Base
  belongs_to  :bill
  
  validates_presence_of :name, :url
end
