class VotesController < ApplicationController
  
  before_filter :find_bill
  
  def edit
    
  end
  
  def create
    redirect_to edit_bill_votes_path(@bill)
  end
  
  def update
    @bill.update_votes(params[:votes])
    redirect_to edit_bill_votes_path(@bill)
  end
  
  def find_bill
    @bill = Bill.find(params[:bill_id])
  end

end
