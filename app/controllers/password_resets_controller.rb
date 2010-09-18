class PasswordResetsController < ApplicationController
  
  skip_before_filter :require_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.reset_perishable_token!
      @user.reload
      UserMailer.password_reset_instructions(@user).deliver
      redirect_to login_path, :notice => "Te enviamos a tu correo las instrucciones para crear una nueva contraseña."
    else
      flash[:error] = "No encontramos el usuario con el correo electronico proporcionado."
      render :action => "new"
    end
  end
  
  def edit
  end
  
  def update
    @user.password = params[:user][:password]  
    @user.password_confirmation = params[:user][:password_confirmation]  
    if @user.save  
      redirect_to root_path, :notice => "La contraseña fue cambiada correctamente"  
    else
      render :action => :edit  
    end
  end  

  private
  
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "Lo sentimos pero no pudimos encontrar tu cuenta. " +
      "Si estás teniendo problemas intentar copiar la URL " +
      "del correo que te enviamos al navegador o intenta de nuevo " +
      "el proceso para cambiar tu contraseña."
      redirect_to login_path
    end
  end
end
