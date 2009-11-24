class View < ActiveRecord::Base
  
  belongs_to  :bill
  
  named_scope :last_week, :conditions => ['created_at between ? AND ?', Time.zone.now - 7.days, Time.zone.now]
  
  def after_create
    self.bill.total_views += 1
    self.bill.update_week_views!
  end
end
