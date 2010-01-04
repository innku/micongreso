class VotesController < ApplicationController
  
  def create
    @bill = Bill.find_by_name(params[:bill_name])
    if @bill
      @bill.create_votes_from_api(params)
    else
      logger.warn "Se intentó registrar los votos para la propuesta '#{params[:bill_name]}', pero no se encontró."
    end
    render :nothing => true
  end

end
