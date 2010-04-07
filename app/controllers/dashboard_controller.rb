class DashboardController < ApplicationController
  
  skip_before_filter :login_required
  
  def index
    respond_to do |wants|
      wants.html { 
        @news = News.latest
        @bills = Bill.limit.recent_popular
        @citizens = User.with_avatar.latest
        @citizen = User.new
      }
      wants.js {
        @bills = Bill.limit.send(params[:type])
      }
    end
  end

end
