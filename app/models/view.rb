class View < ActiveRecord::Base
  
  belongs_to  :bill
  
  scope :last_week, lambda { where('created_at between ? AND ?', Time.zone.now - 7.days, Time.zone.now) }
  
  after_create :update_views_count
  
  def update_views_count
    self.bill.total_views += 1
    self.bill.update_week_views!
  end
end