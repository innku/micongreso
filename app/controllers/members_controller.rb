class MembersController < ApplicationController
  
  require 'fastercsv'
  
  layout "application_new"
  
  skip_before_filter :require_user, :only => [:show]
  load_and_authorize_resource
  
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
    authorize! :create, Member
    FasterCSV.parse(params[:file], {:headers => true}) do |row|
      Member.create_from_csv(row)
    end
    redirect_to members_path
  end
  
  def show
    options = {}
    options = {:name => current_user.name, :email => current_user.email} if current_user
    @message = Message.new(options)
    @votes = @member.votes.limit(5)
    @assistances = @member.assistances.limit(5).includes(:sitting)
    @bills = @member.bills.limit(3)
  end
  
  def new
  end
  
  def create
    if @member.save
      flash[:notice] = "Se guardó el diputado correctamente."
      redirect_to @member
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @member.update_attributes(params[:member])
      flash[:notice] = "Se actualizó la informaciónd el diputado correctamente."
      redirect_to @member
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @member.destroy
    flash[:notice] = "Se eliminó al diputado correctamente."
    redirect_to members_url
  end
end
