module ApplicationHelper
  def admin?(user)
    user && user.admin?
  end

  def display_vote(choice, voteable=nil)
    return "Me gusta" if voteable && voteable.class.name == "News"
    if choice.nil?
      "Te abstuviste de votar"
    else
      choice == true ? "Votaste a favor" : "Votaste en contra"
    end
  end

  def member_vote_class(vote)
    if vote
      return "neutral" if vote.vote.nil?
      vote.vote == true ? "favor" : "contra"
    else
      "neutral"
    end
  end

  def member_vote(vote)
    if vote
      return "Abstención" if vote.vote.nil?
      vote.vote == true ? "A Favor" : "En Contra"
    else
      "Faltó a la sesión"
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
    return "active" if params.blank? && type == "most_viewed"
    "active" if params == type
  end

  def choice_class(vote)
    return "" if vote.nil?
    vote ? "si" : "no"
  end

  def es_date(date)
    "#{date.day} #{MONTHS[date.month]} #{date.year}"
  end

  def vote_date(date)
    if date
      l date, :format => :long
    else
      "Pendiente"
    end
  end

  def bill_status_class(bill, status)
    "selected" if bill.status == status
  end
  
  def link_to_like(voteable, user)
    choice = true
    text = "Me gusta"
    vote_object = user.vote_object(voteable) if user
    if vote_object
      if vote_object.vote == true
        choice = false
        text = "Ya no me gusta"
      end
    end
    
    link_to content_tag(:span, text), send("#{voteable.class.name.downcase}_votes_path", voteable, :vote => choice.to_s), :class => "vote like", :remote => true, :method => :post
  end
end
