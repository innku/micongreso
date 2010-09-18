class UserMailer < ActionMailer::Base
  layout 'email'
  
  default :from => "no-responder@micongreso.mx"
  
  def signup_notification(user)
    @user = user
    @url  = "#{$global_url}/activate/#{user.activation_code}"
    mail(:to => user.email, :subject => "MiCongreso - Por favor activa tu cuenta")
  end
  
  def activation(user)
    @user = user
    @url  = "#{$global_url}/"
    mail(:to => user.email, :subject => "MiCongreso - Tu cuenta ha sido activada!")
  end
  
  def password_reset_instructions(user)
    @user = user
    mail(:to => user.email, :subject => "MiCongreos - Generar nueva contraseña")
  end
  
  def message_to_member(message, member)
    @message = message
    @member = member
    mail(:to => "#{member.email}, mensajes@micongreso.mx", :subject => "Nuevo Mensaje")
  end
  
  def bill(user, bill)
    @user = user
    @bill = bill
    @url  = "#{$global_url}/bills/#{bill.id}"
    mail(:to => user.email, :subject => "MiCongreso - Hay una nueva propuesta, ¡Opina!")
  end
  
  def bill_votes(user, bill)
    @user = user
    @bill = bill
    @url  = "#{$global_url}/bills/#{bill.id}"
    mail(:to => user.email, :subject => "MiCongreso - Ya votaron los diputados, ¡Conoce los resultados!")
  end
  
  def invitation(user, name, email, message)
    @url  = "#{$global_url}/signup"
    @name = name
    @email = email
    @message = message
    
    subject = user ? "#{user.name} te ha invitado a unirte a MiCongreso" : "Te han invitado a unirte a MiCongreso"
    mail(:to => email, :subject => subject)
  end
end
