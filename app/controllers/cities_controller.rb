class CitiesController < ApplicationController
  
  skip_before_filter :require_user
  
  def index
    respond_to do |wants|
      wants.js {
        @cities = City.find_by_full_name(params[:q]) if params[:q]
      }
    end

  end
end
