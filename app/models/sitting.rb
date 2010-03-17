class Sitting < ActiveRecord::Base
  
  has_many  :absences
  
  accepts_nested_attributes_for :absences, :reject_if => lambda { |a| a[:member_name].blank? }, :allow_destroy => true
  
  attr_accessor :publish_absences_on_social_media
  
  def formatted_date
    if self.new_record?
      Date.today.to_s(:es)
    else
      read_attribute(:date).to_s(:es)
    end
  end
  
  def formatted_date=(date)
  end
  
  def after_save
    if publish_absences_on_social_media.to_i == 1
      PingFM.post_to_social_media("Ausencias de la sesion: #{self.name}", "#{$global_url}/sittings/#{self.id}")
    end
  end
end
