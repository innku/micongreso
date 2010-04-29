class RegisterController < ApplicationController
  
  def profile
    @user = current_user
  end
  
  def save_profile
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to notifications_path
    else
      render :action => "edit"
    end
  end
  
  def notifications
    @user = current_user
  end
  
  def save_notifications
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Te enviamos un correo para verificar que tu dirección de correo electrónico sea correcta, por favor sigue las instrucciones en el correo para activar tu cuenta."
      redirect_to success_path
    else
      render :action => "edit"
    end
  end
  
end
