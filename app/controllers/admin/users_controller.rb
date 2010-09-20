module Admin
  class UsersController < BaseController
  
    skip_before_filter  :require_user, :only => [:resend_form, :resend]
    load_and_authorize_resource
  
    def index
      if params[:role]
        @users = User.send(params[:role]).paginate(:page => params[:page])
      else
        @users = User.admin.paginate(:page => params[:page])
      end
    end
  
    def new
    end
  
    def edit
    end
 
    def create
      @user.role = (current_user && current_user.admin?) ? "admin" : "user"
      if @user.save
        redirect_to admin_users_path
        flash[:notice] = "Te acabamos de enviar un correo de activación, da clic en la liga del correo para completar el registro."
      else
        flash[:error]  = "Ocurrió un error, por favor inténtalo de nuevo."
        render :action => 'new'
      end
    end
  
    def update
      if @user.update_attributes(params[:user])
        flash[:notice] = "Los datos del usuario se guardaron correctamente"
        redirect_to admin_users_path
      else
        render :action => "edit"
      end
    end
  
    def destroy
      if !User.last_admin?
        @user.destroy
        flash[:notice] = "Has eliminado correctamente al usuario"
      else
        flash[:error] = "No puedes eliminar al último administrador"
      end
      redirect_to admin_users_path
    end
  end
end