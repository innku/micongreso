class Assistance < ActiveRecord::Base
  
  belongs_to  :sitting
  belongs_to  :member
  
  validates_presence_of :member_id
  validates_uniqueness_of :member_id, :scope => :sitting_id
  
  year_selector = Rails.env.production? ? "EXTRACT(YEAR FROM sittings.date)" : "YEAR(sittings.date)"
  
  scope :present, where('assisted = ?', true)
  scope :absent, where('assisted = ?', false)
  scope :include_member, includes(:member)
  
  def self.month
    where('sittings.date > ?', Date.today - 30.days).includes(:sitting)
  end
  
  def self.year
    where("#{year_selector} = ?", Date.today.year).includes(:sitting)
  end
  
  def member_name
    self.member.name if self.member
  end
  
  def member_name=(string)
    self.member = Member.find_by_name(string)
  end
end
