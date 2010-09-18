class UsersController < ApplicationController
  
  skip_before_filter  :require_user, :only => [:resend_form, :resend]
  
  def index
    @users = User.admins
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
 
  def create
    @user = User.new(params[:user])
    @user.role = (current_user && current_user.admin?) ? "admin" : "user"
    if @user.save
      redirect_to users_path
      flash[:notice] = "Te acabamos de enviar un correo de activación, da clic en la liga del correo para completar el registro."
    else
      flash[:error]  = "Ocurrió un error, por favor inténtalo de nuevo."
      render :action => 'new'
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Los datos del usuario se guardaron correctamente"
      redirect_to users_path
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if (@user.admin? && User.admins.count > 1) || @user.citizen?
      @user.destroy
      flash[:notice] = "Has eliminado correctamente al usuario"
    else
      flash[:error] = "No puedes eliminar al último administrador"
    end
    redirect_to users_path
  end
  
  def resend
    user = User.find_by_email(params[:email])
    if user
      flash[:notice] = "El correo de activación se te envió con éxito."
      UserMailer.signup_notification(user).deliver
      redirect_to login_path
    else
      flash[:error] = "No encontramos un usuario con el correo que nos indicaste."
      redirect_to resend_activation_form_path
    end
  end
  
end
