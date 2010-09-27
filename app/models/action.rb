class Action < ActiveRecord::Base
  
  belongs_to  :bill
  
  validates_presence_of :action_type, :date
  
  TYPES = [["Presentación", "presentation"],
            ["Discusión", "discussion"],
            ["Aprobación", "approval_congress"],
            ["Promulgación", "signature"]]
  
  def self.presentation
    where("action_type = ?", "presentation").first
  end
  
  def self.discussion
    where("action_type = ?", "discussion").first
  end
  
  def self.approval
    where("action_type = ?", "approval_congress").first
  end
  
  def self.signature
    where("action_type = ?", "signature").first
  end
  
  def formatted_date
     if self.new_record?
       Date.today.strftime("%d/%m/%Y")
     else
       read_attribute(:date).strftime("%d/%m/%Y")
     end
   end

   def formatted_date=(date)
   end
end
