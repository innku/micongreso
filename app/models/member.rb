class Member < ActiveRecord::Base
  
  belongs_to  :state
  belongs_to  :party
  
  has_many    :messages
  
  attr_accessor :importing
  
  acts_as_voter
  
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
  
  validates_presence_of   :name, :message => "^Por favor ingrese el nombre del diputado"
  validates_uniqueness_of :name, :message => "^Ya se encuentra un diputado con este nombre", :unless => :is_importing?
  
  validates_presence_of   :email, :message => "^Por favor ingrese el correo electrónico del diputado"
  validates_uniqueness_of :email, :message => "^Ya se encuentra un diputado con este correo", :unless => :is_importing?
  validates_presence_of   :party_id, :message => "^Por favor seleccione el partido"
  validates_presence_of   :state_id, :message => "^Por favor seleccione el estado"
  validates_presence_of   :district, :message => "^Por favor ingrese el distrito del diputado"
  
  named_scope :incomplete, :conditions => ['complete = ?', false]
  named_scope :complete, :conditions => ['complete = ?', true]
  named_scope :duplicate, :conditions => ['duplicate = ?', true]
  
  def self.find_by_email_or_name(string)
    member = find_by_email(string)
    member = find_by_name(string) unless member
    return member
  end
  
  def is_importing?
    importing
  end
  
  def party_abbr
    self.party.abbr
  end
  
  def party_abbr=(party_abbr)
    party = Party.find_by_abbr(party_abbr)
    write_attribute(:party_id, party.id) if party
  end
  
  def party_name
    self.party.name if self.party
  end
  
  def state_name
    self.state.name if self.state
  end
  
  def state_name=(state_name)
    state = State.find_by_name(state_name)
    write_attribute(:state_id, state.id) if state
  end
  
  def self.create_from_csv(row)
    member = Member.new(:name => row['nombre'], 
                        :email => row['correo'],
                        :commission => row['comision'],
                        :district => row['distrito'],
                        :head => row['cabecera'],
                        :election => row['tipo_eleccion'],
                        :birthdate => row['fecha_nacimiento'],
                        :birthplace => row['lugar_nacimiento'],
                        :substitute => row['sustituto'],
                        :party_abbr => row['partido'],
                        :state_name => row['entidad'])
    member.importing = true
    member.complete = false unless member.valid?
    member.duplicate = true if member.same_name_or_email?
    member.save(false)
  end
  
  def same_name_or_email?
    member = Member.find(:first, :conditions => ["name = ? OR email = ?", self.name, self.email])
    return member ? true : false
  end
  
  def before_save
    self.complete = true if self.valid?
  end
end
