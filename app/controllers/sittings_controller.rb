class SittingsController < ApplicationController
  def index
    @sittings = Sitting.all
  end
  
  def show
    @sitting = Sitting.find(params[:id])
    @assistances = @sitting.assistances.include_member.present
    @absences = @sitting.assistances.include_member.absent
  end
  
  def new
    @sitting = Sitting.new
    10.times { @sitting.assistances.build }
  end
  
  def create
    params[:sitting][:bill_ids] ||= []
    @sitting = Sitting.new(params[:sitting])
    if @sitting.save
      flash[:notice] = "Successfully created sitting."
      redirect_to @sitting
    else
      render :action => 'new'
    end
  end
  
  def edit
    @sitting = Sitting.find(params[:id])
  end
  
  def update
    params[:sitting][:bill_ids] ||= []
    @sitting = Sitting.find(params[:id])
    if @sitting.update_attributes(params[:sitting])
      flash[:notice] = "Successfully updated sitting."
      redirect_to @sitting
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @sitting = Sitting.find(params[:id])
    @sitting.destroy
    flash[:notice] = "Successfully destroyed sitting."
    redirect_to sittings_url
  end
end
