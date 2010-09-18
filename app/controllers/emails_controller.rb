class EmailsController < ApplicationController
  
  skip_before_filter :require_user
  
  def bill
    @bill = Bill.find(params[:id])
  end
  
  def bill_votes
    @bill = Bill.find(params[:id])
  end
end