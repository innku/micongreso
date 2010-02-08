class VotesController < ApplicationController
  
  before_filter :find_bill
  
  def edit
    
  end
  
  def create
    redirect_to edit_bill_votes_path(@bill)
  end
  
  def update
    @bill.update_votes(params[:votes])
    logger.warn "Lo va a publicar? #{params[:publish_votes_on_social_media].to_i == 1}"
    @bill.post_to_social_media("Resultados propuesta: #{@bill.name}", bill_url(@bill)) if params[:publish_votes_on_social_media].to_i == 1
    redirect_to edit_bill_votes_path(@bill)
  end
  
  def find_bill
    @bill = Bill.find(params[:bill_id])
  end

end
