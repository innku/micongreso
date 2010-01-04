class DashboardController < ApplicationController
  
  skip_before_filter :login_required, :only => :index
  
  def index
    @news = News.latest
    @bills = Bill.latest_voted
  end

end
