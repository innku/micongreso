class UsersController < ApplicationController
  
  skip_before_filter  :require_user, :only => [:new, :create, :resend_form, :resend]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.make_citizen
    UserSession.disable_magic_states(true) # Do not verify that user has been activated
    if @user.save
      UserMailer.signup_notification(@user).deliver
      redirect_to profile_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    params[:user][:tag_list] ||= []
    if @user.update_attributes(params[:user])
      flash[:notice] = "Se guardaron los cambios del usuario correctamente"
      redirect_to edit_user_path(@user, :tab => params[:tab])
    else
      render :action => 'edit'
    end
  end
  
  def resend_form
  end
  
  def resend
    user = User.find_by_email(params[:email])
    if user && user.activation_code
      flash[:notice] = "El correo de activación se te envió con éxito."
      UserMailer.signup_notification(user).deliver
      redirect_to login_path
    else
      flash[:error] = "No encontramos un usuario con el correo que nos indicaste o tu usuario ya se encuentra activado."
      redirect_to resend_activation_form_path
    end
  end
end
