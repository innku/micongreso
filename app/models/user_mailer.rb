class UserMailer < ActionMailer::Base
  helper :application
  layout 'email'
  
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Por favor activa tu cuenta'
    @body[:url]  = "#{$global_url}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Tu cuenta ha sido activada!'
    @body[:url]  = "#{$global_url}/"
  end
  
  def new_password(user, password)
    setup_email(user)
    @subject    += 'Nueva Contraseña'
    @body[:url]  = "#{$global_url}/"
    @body[:password] = password
  end
  
  def message_to_member(message, member)
    @recipients  = "#{member.email}, mensajes@micongreso.mx"
    @from        = "no-responder@micongreso.mx"
    @subject     = "MiCongreso "
    @sent_on     = Time.now
    @content_type = "text/html"
    @body[:message] = message
    @body[:member] = member
  end
  
  def bill(user, bill)
    setup_email(user)
    @subject    += "Hay una nueva propuesta, ¡Opina!"
    @body[:url]  = "#{$global_url}/bills/#{bill.id}"
    @body[:bill] = bill
  end
  
  def bill_votes(user, bill)
    setup_email(user)
    @subject    += "Ya votaron los diputados, ¡Conoce los resultados!"
    @body[:url]  = "#{$global_url}/bills/#{bill.id}"
    @body[:bill] = bill
  end
  
  def invitation(user, name, email)
    @recipients  = "#{email}"
    @from        = "no-responder@micongreso.mx"
    if user
      @subject     = "#{user.name} te ha invitado a unirte a MiCongreso"
      @body[:user] = user
    else
      @subject     = "Te han invitado a unirte a MiCongreso"
    end
    @sent_on     = Time.now
    @content_type = "text/html"
    @body[:url]  = "#{$global_url}/signup"
    @body[:name] = name
    @body[:email] = email
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "no-responder@micongreso.mx"
      @subject     = "MiCongreso - "
      @sent_on     = Time.now
      @content_type = "text/html"
      @body[:user] = user
    end
end
