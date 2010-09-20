class VotesController < ApplicationController
  
  before_filter :find_voteable
  
  def edit
    @bill = @voteable
    unless @bill.sitting
      flash[:error] = "No puedes selecionar los votos de una propuesta si no está relacionada a una sesión."
      redirect_to @bill
    end
  end
  
  def create
    vote = case params[:vote].to_i
            when 1 then true
            when 0 then false
            when -1 then nil
            else nil
           end
    current_user.vote(@voteable, vote)
    
    if @voteable.class.name == "Bill"
      if vote.nil?
        @voteable.user_votes_neutral += 1
      elsif vote == true
        @voteable.user_votes_for += 1
      elsif vote == false
        @voteable.user_votes_against += 1
      end
      @voteable.save
    end
    
    respond_to do |wants|
      wants.html { redirect_to root_path }
      wants.js
    end
    
  end
  
  def update
    @bill = @voteable
    @bill.update_votes(params[:votes])
    PingFM.post_to_social_media("Resultados propuesta: #{@bill.name}", bill_url(@bill)) if params[:publish_votes_on_social_media].to_i == 1
    User.citizens.each {|user| UserMailer.bill_votes(user, @bill).deliver} if params[:send_emails].to_i == 1
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
