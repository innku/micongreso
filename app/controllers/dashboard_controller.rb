class DashboardController < ApplicationController
  
  skip_before_filter :login_required
  
  def index
    respond_to do |wants|
      wants.html {
        if @state_congress
          @bills = @state_congress.bills.limit.recent_popular
        else
          @bills = Bill.limit.recent_popular
        end
        @news = News.latest
        @citizens = User.with_avatar.latest
        @citizen = User.new
      }
      wants.js {
        if @state_congress
          @bills = @state_congress.bills.limit.send(params[:type])
        else
          @bills = Bill.limit.send(params[:type])
        end
        
      }
    end
  end

end
