class BillsController < ApplicationController
  
  skip_before_filter  :login_required, :only => [:index, :show]
  
  def index
    @bills = Bill.all
  end
  
  def show
    @bill = Bill.find(params[:id])
    @bill.views.create
  end
  
  def new
    @bill = Bill.new
  end
  
  def create
    @bill = Bill.new(params[:bill])
    if @bill.save
      flash[:notice] = "La propuesta se creó correctamente."
      redirect_to bills_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @bill = Bill.find(params[:id])
  end
  
  def update
    @bill = Bill.find(params[:id])
    if @bill.update_attributes(params[:bill])
      flash[:notice] = "La propuesta se actualizó correctamente."
      redirect_to bills_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @bill = Bill.find(params[:id])
    @bill.destroy
    flash[:notice] = "La propuesta ha sido eliminada correctamente."
    redirect_to bills_url
  end
end
