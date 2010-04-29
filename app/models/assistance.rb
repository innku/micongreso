class Assistance < ActiveRecord::Base
  
  belongs_to  :sitting
  belongs_to  :member
  
  validates_presence_of :member_id, :message => "^No encontramos el nombre del diputado."
  validates_uniqueness_of :member_id, :scope => :sitting_id
  
  year_selector = Rails.env.production? ? "EXTRACT(YEAR FROM sittings.date)" : "YEAR(sittings.date)"
  
  named_scope :month, :include => :sitting, :conditions => ['sittings.date > ?', Date.today - 30.days]
  named_scope :year, :include => :sitting, :conditions => ["#{year_selector} = ?", Date.today.year ]
  named_scope :present, :conditions => ['assisted = ?', true]
  named_scope :absent, :conditions => ['assisted = ?', false]
  named_scope :include_member, :include => :member
  
  def member_name
    self.member.name if self.member
  end
  
  def member_name=(string)
    self.member = Member.find_by_name(string)
  end
end
