SHORT_MONTHS = ["","Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
MONTHS = ["", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!( 
  :es => "%d/%m/%Y",
  :es_short => "%d %b %y",
  :es_long => "%d %B %Y" )

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!( 
  :es => "%d/%m/%Y",
  :es_short => "%d %b %y",
  :time => "%H:%M")
  
