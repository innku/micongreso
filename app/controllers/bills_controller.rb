class BillsController < ApplicationController
  
  skip_before_filter  :require_user, :only => [:index, :show]
  load_and_authorize_resource :except => [:index, :show]
  
  layout "application_new"
  
  def index
    if params[:search]
      @bills = Bill.name_or_description_like(params[:search])
    elsif params[:tag_id]
      @tag = ActsAsTaggableOn::Tag.find(params[:tag_id])
      @bills = Bill.tagged_with(@tag.name)
    elsif params[:month] && params[:year]
      @bills = Bill.monthly(params[:month], params[:year])
    else
      @bills = Bill.recent.paginate(:page => params[:page], :per_page => 20)
    end
  end
  
  def show
    @bill = Bill.find(params[:id])
    @bill.views.create
    @lastest_action = @bill.actions.last
  end
  
  def new
    3.times { @bill.resources.build }
  end
  
  def create
    if @bill.save
      flash[:notice] = "La propuesta se creó correctamente."
      redirect_to @bill
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    params[:bill][:tag_list] ||= []
    if @bill.update_attributes(params[:bill])
      flash[:notice] = "La propuesta se actualizó correctamente."
      redirect_to @bill
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @bill.destroy
    flash[:notice] = "La propuesta ha sido eliminada correctamente."
    redirect_to bills_url
  end
end
