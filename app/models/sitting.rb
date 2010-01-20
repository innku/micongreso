class Sitting < ActiveRecord::Base
  
  has_many  :absences
  
  accepts_nested_attributes_for :absences, :reject_if => lambda { |a| a[:member_name].blank? }, :allow_destroy => true
  
  def formatted_date
    if self.new_record?
      Date.today.to_s(:es)
    else
      read_attribute(:date).to_s(:es)
    end
  end
  
  def formatted_date=(date)
  end
end
