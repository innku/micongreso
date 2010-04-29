class CitizensController < ApplicationController
  
  skip_before_filter  :login_required, :only => [:new, :create]
  
  def index
    @citizens = User.citizens
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
      redirect_to profile_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @citizen = current_user
  end
  
  def update
    @citizen = current_user
    params[:user][:tag_ids] ||= []
    if @citizen.update_attributes(params[:user])
      flash[:notice] = "Se guardaron los cambios del usuario correctamente"
      redirect_to edit_citizen_path(@citizen, :tab => params[:tab])
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
