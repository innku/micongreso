class Member < ActiveRecord::Base
  
  belongs_to  :state
  belongs_to  :party
  
  has_many    :messages
  
  production = ENV['RAILS_ENV'] == 'production'
  
  has_attached_file :picture, :styles => { :medium => "360x240>", :thumb => "150x100>" },
                            :storage => (production ? :s3 : :filesystem),
                            :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                            :path => (production ? ":attachment/:id/:style/:basename.:extension" : "public/system/:attachment/:id/:style/:basename.:extension"),
                            :bucket => $paperclip_bucket,
                            :default_url => "/images/missing.png"

  validates_attachment_size         :picture, :less_than => 10.megabytes, :message => "^El archivo debe ser menor a 10 MegaBytes"
  validates_attachment_content_type :picture, :content_type => ['image/jpeg','image/jpg','image/jpeg','image/pjpeg','image/png','image/x-png','image/gif'], 
                                              :message => "^Solo están permitidas las imágenes tipo JPEG, PNG y GIF."
  
  validates_presence_of :name, :message => "^Por favor ingrese el nombre del diputado"
  validates_presence_of :email, :message => "^Por favor ingrese el correo electrónico del diputado"
  validates_presence_of :party_id, :message => "^Por favor seleccione el partido"
  validates_presence_of :state_id, :message => "^Por favor seleccione el estado"
  validates_presence_of :district, :message => "^Por favor ingrese el distrito del diputado"
  
end
