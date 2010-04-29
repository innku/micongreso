class AssistancesController < ApplicationController
  def index
    @assistances = Assistance.all
  end
  
  def show
    @assistance = Assistance.find(params[:id])
  end
  
  def new
    @assistance = Assistance.new
  end
  
  def create
    @assistance = Assistance.new(params[:assistance])
    if @assistance.save
      flash[:notice] = "Successfully created assistance."
      redirect_to @assistance
    else
      render :action => 'new'
    end
  end
  
  def edit
    @assistance = Assistance.find(params[:id])
  end
  
  def update
    @assistance = Assistance.find(params[:id])
    if @assistance.update_attributes(params[:assistance])
      flash[:notice] = "Successfully updated assistance."
      redirect_to @assistance
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @assistance = Assistance.find(params[:id])
    @assistance.destroy
    flash[:notice] = "Successfully destroyed assistance."
    redirect_to assistances_url
  end
end
