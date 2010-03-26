class Absence < ActiveRecord::Base
  
  belongs_to  :sitting
  belongs_to  :member
  
  validates_presence_of :member_id, :message => "^No encontramos el nombre del diputado."
  
  year_selector = Rails.env.production? ? "EXTRACT(YEAR FROM sittings.date)" : "YEAR(sittings.date)"
  
  named_scope :month, :include => :sitting, :conditions => ['sittings.date > ?', Date.today - 30.days]
  named_scope :year, :include => :sitting, :conditions => ["#{year_selector} = ?", Date.today.year ]
  
  def member_name
    self.member.name if self.member
  end
  
  def member_name=(string)
    self.member = Member.find_by_name(string)
  end
end
