class ActionsController < ApplicationController
  
  skip_before_filter :require_user
  
  layout "application_new"
  
  def index
    @bill = Bill.find(params[:bill_id])
    @actions = @bill.actions
  end
end