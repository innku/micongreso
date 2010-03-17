class Profile < ActiveRecord::Base
  
  belongs_to  :user
  
  POLITICAL_VIEWS = ["Ultra Conservador", "Consevador", "Conservador Moderado", "Centro", "Liberal Moderado", "Liberal", "Ultra Liberal", "No Sé"]
  OCUPATIONS = ["Agricultura, Caza, Silvicultura", "Hidrocarburos, Minas y Canteras", "Industria  Manufacturera", "Construcción", "Electricidad, Gas y Agua", "Comercio e Instituciones Financieras", "Transporte, Almacenaje y Comunicaciones", "Servicios", "Público", "Otros"]
  EDUCATION_LEVELS = ["Primaria", "Secundaria", "Bachillerato", "Técnico", "Profesional", "Posgrado"]
  MARITAL_STATUSES = ["Soltero(a)", "Casado(a)", "Divorciado(a)", "Viudo(a)"]
  
end
