class DashboardController < ApplicationController
  
  skip_before_filter :login_required, :only => :index
  
  def index
    respond_to do |wants|
      wants.html { 
        @news = News.latest
        @bills = Bill.voted
        @citizens = User.with_avatar.latest
        @citizen = User.new
      }
      wants.js {
        @bills = Bill.send(params[:type])
      }
    end
  end

end
