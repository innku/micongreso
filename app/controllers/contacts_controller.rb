class ContactsController < ApplicationController
  
  skip_before_filter :require_user, :only => [:create, :deliver]
  authorize_resource
  
  def index
    @contacts = Contact.all
  end
  
  def show
    @contact = Contact.find(params[:id])
  end
  
  def new
    @contact = Contact.new
  end
  
  def create    
    respond_to do |wants|
      wants.html { 
        if Contact.send_invitations(current_user, params[:provider], params[:login], params[:password])
          flash[:notice] = "Las invitaciones se enviaron correctamente a los contactos de su cuenta de correo."
          if current_user
            redirect_to edit_user_path(current_user)
          else
            redirect_to root_path
          end
        else
          flash[:error] = "El usuario/correo y/o la contraseña proporcionada son incorrectos"
          render :action => 'new'
        end
      }
      wants.js {
        token = Authlogic::Random.friendly_token
        session[:token] = token
        @success = Contact.save_contacts(current_user, params[:provider], params[:login], params[:password], token)
        if current_user
          @contacts = current_user.contacts
        else
          @contacts = Contact.find_all_by_token(token)
        end
      }
    end
  end
  
  def deliver
    authorize! :deliver, :contacts
    respond_to do |wants|
      wants.js {
        Contact.deliver_invitations_later({:contact_ids => params[:contact_ids], :message => params[:message], :user => current_user})
      }
    end
  end
  
  def edit
    @contact = Contact.find(params[:id])
  end
  
  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash[:notice] = "Successfully updated contact."
      redirect_to @contact
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    flash[:notice] = "Successfully destroyed contact."
    redirect_to contacts_url
  end
end
