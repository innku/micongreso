class Sitting < ActiveRecord::Base
  
  has_many  :assistances
  has_many  :absences, :class_name => 'Assistance', :conditions => ['assistances.assisted = ?', false]
  has_many  :members, :through => :assistances
  has_many  :bills
  belongs_to  :term
  
  accepts_nested_attributes_for :assistances, :reject_if => lambda { |a| a[:member_name].blank? }, :allow_destroy => true
  
  attr_accessor :publish_assistances_on_social_media
    
  def self.year(year)
    year_selector = Rails.env.production? ? "EXTRACT(YEAR FROM sittings.date)" : "YEAR(sittings.date)"
    where("#{year_selector} = ?", year)
  end
  
  def formatted_date
    if self.new_record?
      Date.today.to_s(:es)
    else
      read_attribute(:date).to_s(:es)
    end
  end
  
  def formatted_date=(date)
  end
  
  def before_validation
    self.assistances.present.destroy_all
  end
  
  def after_save
    if publish_assistances_on_social_media.to_i == 1
      PingFM.post_to_social_media("Ausencias de la sesion: #{self.name}", "#{$global_url}/sittings/#{self.id}")
    end
    
    (Member.active-self.members).each do |member|
      self.assistances.create(:member_id => member.id, :assisted => 1)
    end
  end
end
