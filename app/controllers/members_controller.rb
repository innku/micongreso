class MembersController < ApplicationController
  
  skip_before_filter :login_required, :only => [:index, :show]
  
  def index
    @members = Member.all
  end
  
  def show
    @member = Member.find(params[:id])
    @message = Message.new
  end
  
  def new
    @member = Member.new
  end
  
  def create
    @member = Member.new(params[:member])
    if @member.save
      flash[:notice] = "Successfully created member."
      redirect_to @member
    else
      render :action => 'new'
    end
  end
  
  def edit
    @member = Member.find(params[:id])
  end
  
  def update
    @member = Member.find(params[:id])
    if @member.update_attributes(params[:member])
      flash[:notice] = "Successfully updated member."
      redirect_to @member
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    flash[:notice] = "Successfully destroyed member."
    redirect_to members_url
  end
end
