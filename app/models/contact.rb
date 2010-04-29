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
        begin
          existing = Contact.find_by_email(c[1])
          unless existing
            contact = Contact.new(:name => c[0], :email => c[1])
            contact.user_id = user.id if user
            contact.save!
            UserMailer.deliver_invitation(user, c[0], c[1])
          end
        rescue Net::SMTPSyntaxError
          RAILS_DEFAULT_LOGGER.debug "Net::SMTPSyntaxError para el correo: #{c[1]}"
        end
      end
      return true
    rescue Contacts::AuthenticationError
      RAILS_DEFAULT_LOGGER.debug "AuthenticationError: El login (#{login}) y/o la contraseña son incorrectos."
      return false
    end
  end
  
  def self.save_contacts(user, provider, login, password, token)
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
        existing = Contact.find_by_email(c[1])
        unless existing
          contact = Contact.new(:name => c[0], :email => c[1])
          if user
            contact.user_id = user.id 
          else
            contact.token = token
          end
          contact.save!
        end
      end
      return true
    rescue Contacts::AuthenticationError
      RAILS_DEFAULT_LOGGER.debug "AuthenticationError: El login (#{login}) y/o la contraseña son incorrectos."
      return false
    end
  end
  
  def self.deliver_invititations(options={})
    options[:contact_ids].each do |contact_id|
      contact = Contact.find(contact_id.to_i)
      contact.invited_on = Time.now
      contact.save
      UserMailer.deliver_invitation(options[:user], contact.name, contact.email, options[:message])
    end
  end
  
  def self.deliver_invitations_later(options={})
    if Rails.env.production?
      heroku = Heroku::Client.new("federico@innku.com", "ziggy1304")
      heroku.set_workers("diputadovirtual", 1)
    end
    self.send_later(:deliver_invititations, options)
  end
  
end
