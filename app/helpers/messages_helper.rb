module MessagesHelper
  def message_form_height(current_user)
    current_user ? 400 : 460
  end
end