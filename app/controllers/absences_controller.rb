class AbsencesController < ApplicationController
  def index
    @absences = Absence.all
  end
  
  def show
    @absence = Absence.find(params[:id])
  end
  
  def new
    @absence = Absence.new
  end
  
  def create
    @absence = Absence.new(params[:absence])
    if @absence.save
      flash[:notice] = "Successfully created absence."
      redirect_to @absence
    else
      render :action => 'new'
    end
  end
  
  def edit
    @absence = Absence.find(params[:id])
  end
  
  def update
    @absence = Absence.find(params[:id])
    if @absence.update_attributes(params[:absence])
      flash[:notice] = "Successfully updated absence."
      redirect_to @absence
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @absence = Absence.find(params[:id])
    @absence.destroy
    flash[:notice] = "Successfully destroyed absence."
    redirect_to absences_url
  end
end
