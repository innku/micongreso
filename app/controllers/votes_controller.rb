class VotesController < ApplicationController
  
  before_filter :find_voteable
  
  def edit
    @bill = @voteable
  end
  
  def create
    vote = params[:vote].to_i == 1 ? true : false
    current_user.vote(@voteable, vote)
    
    respond_to do |wants|
      wants.html { redirect_to root_path }
      wants.js
    end
    
  end
  
  def update
    @bill = @voteable
    @bill.update_votes(params[:votes])
    logger.warn "Lo va a publicar? #{params[:publish_votes_on_social_media].to_i == 1}"
    PingFM.post_to_social_media("Resultados propuesta: #{@bill.name}", bill_url(@bill)) if params[:publish_votes_on_social_media].to_i == 1
    User.citizens.each {|citizen| UserMailer.deliver_bill_votes(citizen, @bill)} if params[:send_emails].to_i == 1
    redirect_to edit_bill_votes_path(@bill)
  end
  
  def find_voteable
    if params[:bill_id]
      @voteable = Bill.find(params[:bill_id])
    elsif params[:news_id]
      @voteable = News.find(params[:news_id])
    end
  end

end
