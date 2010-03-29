# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    
  def admin?(user)
    user && user.admin?
  end
  
  def display_vote(choice, voteable=nil)
    return "Me gusta" if voteable && voteable.class.name == "News"
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
  
  def tag_classes(tagger, tag)
    tag_classes = "tag"
    tag_classes += " selected_tag" if tagger.tags.include?(tag)
    return tag_classes
  end
  
  def show_votes?(vote_type, votes_array)
    votes_array[vote_type] if votes_array[vote_type+3] > 6
  end
  
  def tab_class(params, type)
    return "active" if params.blank? && type == "recent_popular"
    "active" if params == type
  end
  
  def es_date(date)
    "#{date.day} #{MONTHS[date.month]} #{date.year}"
  end
end
