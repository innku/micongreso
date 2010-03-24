class Profile < ActiveRecord::Base
  
  belongs_to  :user
  
  production = Rails.env == 'production'
  
  has_attached_file :avatar, :styles => { :medium => "192x192>", :small => "96x96>", :thumb => "40x40#" },
                            :storage => (production ? :s3 : :filesystem),
                            :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                            :path => (production ? ":attachment/:id/:style/:basename.:extension" : "public/system/:attachment/:id/:style/:basename.:extension"),
                            :bucket => $paperclip_bucket,
                            :default_url => "/images/missing.png"

  validates_attachment_size         :avatar, :less_than => 10.megabytes, :message => "^El archivo debe ser menor a 10 MegaBytes"
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg','image/jpg','image/jpeg','image/pjpeg','image/png','image/x-png','image/gif'], 
                                              :message => "^Solo están permitidas las imágenes tipo JPEG, PNG y GIF."
  
  POLITICAL_VIEWS = ["Ultra Conservador", "Consevador", "Conservador Moderado", "Centro", "Liberal Moderado", "Liberal", "Ultra Liberal", "No Sé"]
  OCUPATIONS = ["Agricultura, Caza, Silvicultura", "Hidrocarburos, Minas y Canteras", "Industria  Manufacturera", "Construcción", "Electricidad, Gas y Agua", "Comercio e Instituciones Financieras", "Transporte, Almacenaje y Comunicaciones", "Servicios", "Público", "Otros"]
  EDUCATION_LEVELS = ["Primaria", "Secundaria", "Bachillerato", "Técnico", "Profesional", "Posgrado"]
  MARITAL_STATUSES = ["Soltero(a)", "Casado(a)", "Divorciado(a)", "Viudo(a)"]
  
end
