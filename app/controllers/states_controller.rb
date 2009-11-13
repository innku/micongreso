class StatesController < ApplicationController
  def index
    @states = State.all
  end
  
  def show
    @state = State.find(params[:id])
  end
  
  def new
    @state = State.new
  end
  
  def create
    @state = State.new(params[:state])
    if @state.save
      flash[:notice] = "Successfully created state."
      redirect_to @state
    else
      render :action => 'new'
    end
  end
  
  def edit
    @state = State.find(params[:id])
  end
  
  def update
    @state = State.find(params[:id])
    if @state.update_attributes(params[:state])
      flash[:notice] = "Successfully updated state."
      redirect_to @state
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @state = State.find(params[:id])
    @state.destroy
    flash[:notice] = "Successfully destroyed state."
    redirect_to states_url
  end
end
