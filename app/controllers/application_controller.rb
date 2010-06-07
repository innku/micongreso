# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  include AuthenticatedSystem
  #include ApiAuthorizedFilter
  
  before_filter :login_required, :find_local_congress
  
  def find_local_congress
    @state_congress = State.find_by_subdomain(current_subdomain) unless current_subdomain.blank?
  end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
