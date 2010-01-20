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
  
  def display?(value)
    "display: none;" unless value
  end
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), :class => "add_field")
  end
  
  def yes_or_no(value)
    value ? "Si" : "No"
  end
end
