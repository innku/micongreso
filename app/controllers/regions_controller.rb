class RegionsController < ApplicationController
  
  skip_before_filter  :require_user
  
  def show
    @region = Region.find(params[:id])
  end
end
