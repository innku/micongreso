class ApiAuthorizedFilter
  def before(controller)
    return true unless controller.params[:api_key]
    user = User.find_by_api_key(controller.params[:api_key])
    controller.current_user = user if user
  end

  def after(controller)
    controller.current_user = nil
  end
end