class Message < ActiveRecord::Base  
  belongs_to  :member
  
  validates_presence_of :text, :name
  
  validates_presence_of   :email
  validates_format_of     :email, :with => Authlogic::Regex.email
  
  after_create :deliver_message
  
  def deliver_message
    UserMailer.message_to_member(self, self.member).deliver
  end
end
