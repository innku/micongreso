class DashboardController < ApplicationController
  
  skip_before_filter :require_user
  
  layout "application_new"
  
  def index
    respond_to do |wants|
      wants.html {
        @bills = Bill.limit(5).most_viewed
        @news = News.latest
        @users = User.with_avatar.latest
        @user = User.new
      }
      wants.js {
        @bills = Bill.limit(5).send(params[:type])
      }
    end
  end

end
