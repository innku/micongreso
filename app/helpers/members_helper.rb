module MembersHelper
  
  def show_district_field?(member)
    "display: none;" if member.proportional?
  end
  
  def display_assistance(assistance)
    assisted = assistance.assisted
    if assisted
      css_class = "positive"
      text = "Asistió"
    else
      css_class = "negative"
      text = "Faltó"
    end
    content_tag(:span, text, :class => css_class)
  end
  
  def total_assistances(member)
    assistances = member.assistances.present.count
    absences = member.assistances.absent.count
    total_sessions = member.assistances.count
    percentage = number_to_percentage((absences.to_f/assistances.to_f)*100, :precision => 0)
    content_tag(:span, "#{assistances} de #{total_sessions} (Faltas #{percentage})")
  end
end
