class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
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
    @user.role = current_user ? "admin" : "user"
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_to users_path
      flash[:notice] = "Se le envió un correo de activación, debe dar clic en la liga del correo para completar el registro."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
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

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
end
