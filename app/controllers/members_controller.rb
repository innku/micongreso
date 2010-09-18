class MembersController < ApplicationController
  
  require 'fastercsv'
  
  skip_before_filter :require_user, :only => [:show]
  
  def index
    respond_to do |wants|
      wants.html {
        @members = Member.complete
        @incomplete_members = Member.incomplete
        @duplicate_members = Member.duplicate
      }
      wants.js {
        @members = Member.name_like(params[:q]) if params[:q]
      }
    end

  end
  
  def import
    FasterCSV.parse(params[:file], {:headers => true}) do |row|
      Member.create_from_csv(row)
    end
    
    redirect_to members_path
  end
  
  def show
    @member = Member.find(params[:id])
    if current_user
      @message = Message.new(:name => current_user.name, :email => current_user.email)
    else
      @message = Message.new
    end
    @search_member = SearchMember.new
    @parties = Party.all
    @states = State.all
    @bills = Bill.single_voted.limit(5)
  end
  
  def new
    @member = Member.new
  end
  
  def create
    @member = Member.new(params[:member])
    if @member.save
      flash[:notice] = "Se guardó el diputado correctamente."
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
      flash[:notice] = "Se actualizó la informaciónd el diputado correctamente."
      redirect_to @member
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    flash[:notice] = "Se eliminó al diputado correctamente."
    redirect_to members_url
  end
end
