module CitizensHelper
  
  def selected_tab(tab)
    tab ? tab.to_i : 0
  end
end
