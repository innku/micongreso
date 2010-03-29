class ContactsController < ApplicationController
  
  skip_before_filter :login_required, :create
  
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
    if Contact.send_invitations(current_user, params[:provider], params[:login], params[:password])
      flash[:notice] = "Las invitaciones se enviaron correctamente a los contactos de su cuenta de correo."
      if current_user
        redirect_to edit_citizen_path(current_user)
      else
        redirect_to root_path
      end
    else
      flash[:error] = "El usuario/correo y/o la contraseña proporcionada son incorrectos"
      render :action => 'new'
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
