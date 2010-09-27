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
    @vote = current_user.update_or_create_vote(@voteable, params[:vote])
    @show = params[:show]
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
