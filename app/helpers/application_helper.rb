# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def admin?(user)
    user && user.admin?
  end
  
  def display_vote(choice)
    if choice.nil?
      "Abstención"
    else
      choice == true ? "Favor" : "Contra"
    end
  end
end
