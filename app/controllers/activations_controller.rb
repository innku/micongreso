class ActivationsController < ApplicationController
  
  skip_before_filter :require_user
  
  def create
    @user = User.find_by_activation_code(params[:activation_code])
    
    if @user && !@user.active?
      if @user.activate!
        flash[:notice] = "Ha completado su registro"
        UserMailer.activation(@user).deliver
        redirect_to root_path
      else
        render :action => :new
      end
    else
      flash[:error] = "No encontramos el código de activación. Por favor haga clic en el correo que le enviamos."
      redirect_to root_path
    end
  end

end
