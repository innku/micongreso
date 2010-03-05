module MembersHelper
  
  def show_district_field?(member)
    "display: none;" if member.proportional?
  end
end
