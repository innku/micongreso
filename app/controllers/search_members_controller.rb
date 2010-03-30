class SearchMembersController < ApplicationController
  
  skip_before_filter :login_required
  
  def show
    @search_member = SearchMember.find(params[:id])
    @members = Member.included.search(@search_member.conditions).paginate(:page => params[:page])
    @parties = Party.all
    @states = State.all
  end
  
  def new
    @search_member = SearchMember.new
    @members = Member.included.paginate(:page => params[:page])
    @parties = Party.all
    @states = State.all
  end
  
  def group
    @search_member = SearchMember.new
    @search_member.party_id = params[:party_id] if params[:party_id]
    @search_member.state_id = params[:state_id] if params[:state_id]
    if @search_member.save
      redirect_to @search_member
    else
      render :action => "new"
    end
  end
  
  def create
    @search_member = SearchMember.new(params[:search_member])
    if @search_member.save
      redirect_to @search_member
    else
      render :action => 'new'
    end
  end
  
  def update
    @search_member = SearchMember.find(params[:id])
    if @search_member.update_attributes(params[:search_member])
      redirect_to @search_member
    else
      render :action => 'new'
    end
  end
end
