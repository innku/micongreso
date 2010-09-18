class DashboardController < ApplicationController
  
  skip_before_filter :require_user
  
  def index
    respond_to do |wants|
      wants.html {
        @bills = Bill.limit(5).recent_popular
        @news = News.latest
        @citizens = User.with_avatar.latest
        @citizen = User.new
      }
      wants.js {
        @bills = Bill.limit(5).send(params[:type])
      }
    end
  end

end
