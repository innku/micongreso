class BillsController < ApplicationController
  
  skip_before_filter  :login_required, :only => [:index, :show]
  
  def index
    if params[:search]
      @bills = Bill.name_or_description_like(params[:search])
    elsif params[:tag_id]
      @tag = Tag.find(params[:tag_id])
      @bills = Bill.find_tagged_with(@tag.name)
    elsif params[:month] && params[:year]
      @bills = Bill.monthly(params[:month], params[:year])
    else
      @bills = Bill.all
    end
  end
  
  def show
    @bill = Bill.find(params[:id])
    @bill.views.create
    @related_bills = Bill.find_tagged_with(@bill.tags)-[@bill]
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
    params[:bill][:tag_ids] ||= []
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
