class Message < ActiveRecord::Base
  
  include Authentication
  
  belongs_to  :member
  
  validates_presence_of :text, :message => "^Te faltó escribir el mensaje"
  validates_presence_of :name, :message => "^Te faltó escribir tu nombre"
  
  validates_presence_of   :email, :message => "^Te faltó escribir tu correo electrónico"
  validates_format_of     :email, :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  def after_create
    UserMailer.deliver_message_to_member(self, self.member)
  end
end
