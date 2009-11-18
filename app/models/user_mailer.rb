class UserMailer < ActionMailer::Base
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
  
  def message_to_member(message, member)
    @recipients  = "#{member.email}, mensajes@diputadovirtual.mx"
    @from        = "no-responder@diputadorvirtual.mx"
    @subject     = "Diputado Virtual "
    @sent_on     = Time.now
    @body[:message] = message
    @body[:member] = member
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "no-responder@diputadorvirtual.mx"
      @subject     = "Diputado Virtual "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
