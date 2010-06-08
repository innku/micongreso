class DashboardController < ApplicationController
  
  skip_before_filter :login_required
  
  def index
    respond_to do |wants|
      wants.html {
        @bills = Bill.limit.recent_popular
        @news = News.latest
        @citizens = User.with_avatar.latest
        @citizen = User.new
      }
      wants.js {
        @bills = Bill.limit.send(params[:type])
      }
    end
  end

end
