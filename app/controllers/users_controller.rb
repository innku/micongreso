class UsersController < ApplicationController
  
  skip_before_filter  :login_required, :only => [:activate, :resend_form, :resend]
  
  def index
    @users = User.all
  end
  
  # render new.rhtml
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
 
  def create
    #logout_keeping_session!
    @user = User.new(params[:user])
    @user.role = (current_user && current_user.admin?) ? "admin" : "user"
    success = @user && @user.save
    if success && @user.errors.empty?
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

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Ha completado su registro, ingrese su correo y contraseña."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "No encontramos el código de activación. Por favor haga clic en el correo que le enviamos."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
  def resend
    user = User.find_by_email(params[:email])
    if user
      flash[:notice] = "El correo de activación se te envió con éxito."
      UserMailer.deliver_signup_notification(user)
      redirect_to login_path
    else
      flash[:error] = "No encontramos un usuario con el correo que nos indicaste."
      redirect_to resend_activation_form_path
    end
  end
  
end
