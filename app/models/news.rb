class News < ActiveRecord::Base
  
  validates_presence_of :title, :message => "^Te faltó el título"
  validates_presence_of :abstract, :message => "^Te faltó el resumen"
  validates_presence_of :body, :message => "^Te faltó el cuerpo de la noticia"
  
  acts_as_taggable
  acts_as_commentable
  
  production = ENV['RAILS_ENV'] == 'production'
  
  has_attached_file :photo, :styles => { :medium => "360x240>", :thumb => "150x100>" },
                            :storage => (production ? :s3 : :filesystem),
                            :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                            :path => (production ? ":attachment/:id/:style/:basename.:extension" : "public/system/:attachment/:id/:style/:basename.:extension"),
                            :bucket => $paperclip_bucket

  validates_attachment_size         :photo, :less_than => 10.megabytes, :message => "^El archivo debe ser menor a 10 MegaBytes"
  validates_attachment_content_type :photo, :content_type => ['image/jpeg','image/jpg','image/jpeg','image/pjpeg','image/png','image/x-png','image/gif'], 
                                              :message => "^Solo están permitidos documentos tipo JPEG, PNG, y GIF."
  
  def formatted_date
    if self.new_record?
      Date.today.to_s(:es)
    else
      read_attribute(:date).to_s(:es)
    end
  end
  
  def formatted_date=(date)
  end
end