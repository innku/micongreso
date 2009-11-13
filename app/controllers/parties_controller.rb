class PartiesController < ApplicationController
  def index
    @parties = Party.all
  end
  
  def new
    @party = Party.new
  end
  
  def create
    @party = Party.new(params[:party])
    if @party.save
      flash[:notice] = "Se creó correctamente el partido político."
      redirect_to parties_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @party = Party.find(params[:id])
  end
  
  def update
    @party = Party.find(params[:id])
    if @party.update_attributes(params[:party])
      flash[:notice] = "Se actualizó correctamente el partido político."
      redirect_to parties_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @party = Party.find(params[:id])
    @party.destroy
    flash[:notice] = "Se eliminó el partico correctamente."
    redirect_to parties_url
  end
end
