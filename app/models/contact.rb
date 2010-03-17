class Contact < ActiveRecord::Base

  belongs_to  :user
  
  # Envía un correo a todos los usuarios guardados en los contactos del servicio de correo (Gmail, Hotmail o Yahoo) y los guarda
  # en la base de datos para futuras referencias.
  def self.send_invitations(user, provider, login, password)
    begin
      return false if login.blank? || password.blank?
      if provider
        contacts = Contacts.new(provider.to_sym, login, password).contacts
      else
        contacts = Contacts.guess(login, password)
        return false if contacts.empty?
      end
      contacts.compact!
      contacts.delete_if {|c| c[1].blank? } # Eliminar el registro si no trae correo electrónico
      contacts.each do |c|
        user.contacts.create!(:name => c[0], :email => c[1])
        UserMailer.deliver_invitation(user, c[0], c[1])
      end
      return true
    rescue Contacts::AuthenticationError
      RAILS_DEFAULT_LOGGER.debug "AuthenticationError: El login (#{login}) y/o la contraseña son incorrectos."
      return false
    end
  end
end
