class CitizensController < ApplicationController
  
  skip_before_filter  :login_required, :only => [:new, :create]
  
  def index
    @citizens = User.all
  end
  
  def show
    @citizen = User.find(params[:id])
  end
  
  def new
    @citizen = User.new
  end
  
  def create
    @citizen = User.new(params[:user])
    @citizen.make_citizen 
    if @citizen.save
      self.current_user = @citizen
      redirect_to root_path
      flash[:notice] = "Te acabamos de enviar un correo de activación, da clic en la liga del correo para completar el registro."
    else
      flash[:error]  = "Ocurrió un error, por favor inténtalo de nuevo."
      render :action => 'new'
    end
  end
  
  def edit
    @citizen = User.find(params[:id])
  end
  
  def update
    @citizen = User.find(params[:id])
    if @citizen.update_attributes(params[:citizen])
      flash[:notice] = "Successfully updated citizen."
      redirect_to @citizen
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @citizen = User.find(params[:id])
    @citizen.destroy
    flash[:notice] = "Successfully destroyed citizen."
    redirect_to citizens_url
  end
end
