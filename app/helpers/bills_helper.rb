module BillsHelper
  
  def link_to_user_vote(user, bill, choice, options={})
    css_class = ["vote"]
    vote_object = user.vote_object(bill) if user
    css_class << "voted" if vote_object && vote_object.vote == choice
    if choice
      text = "Vota a favor"
      css_class << "si"
    else
      text = "Vota en contra"
      css_class << "no"
    end
    
    link_to content_tag(:span, text), bill_votes_path(bill, :vote => choice.to_s, :show => true), :class => css_class.join(" "), :remote => true, :method => :post
  end
  
  def activity_bar(bill)
    presentation = bill.actions.presentation
    discussion = bill.actions.discussion
    approval = bill.actions.approval
    signature = bill.actions.signature
    
    presentation_html = action_html(presentation, "Presentación")
    discussion_html = action_html(discussion, "Discusión")
    approval_html = action_html(approval, "Aprobación")
    signature_html = action_html(signature, "Promulgación")
    
    presentation_html + discussion_html + approval_html + signature_html
  end
  
  def action_html(action, name)
    css_class = ["action"]
    css_class << "completed" if action
    
    date = action ? l(action.date) : ""
    date_html = content_tag(:div, date, :class => "date")
    content_tag(:div, content_tag(:div, name, :class => "name") + date_html, :class => css_class.join(" "))
  end
end