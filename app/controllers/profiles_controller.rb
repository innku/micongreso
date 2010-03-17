class ProfilesController < ApplicationController
  def create
    @profile = Profile.new(params[:profile])
    if @profile.save
      flash[:notice] = "Successfully created profile."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Successfully updated profile."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
end
