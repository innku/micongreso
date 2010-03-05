class RegionsController < ApplicationController
  
  skip_before_filter  :login_required
  
  def show
    @region = Region.find(params[:id])
  end
end
