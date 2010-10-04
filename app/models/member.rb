class Member < ActiveRecord::Base
  
  cattr_reader :per_page
  @@per_page = 50
  
  belongs_to  :state
  belongs_to  :party
  belongs_to  :district
  belongs_to  :term
  
  belongs_to  :congress, :class_name => "State"
    
  has_many    :messages,  :dependent => :destroy
  has_many    :assistances,  :dependent => :destroy
  has_many    :absences, :class_name => 'Assistance', :conditions => {:assisted => false}
  has_many    :bills
  
  attr_accessor :importing
  
  acts_as_voter
  
  #production = Rails.env.production?
  production = true
  
  has_attached_file :picture, :styles => { :medium => "360x240>", :small => "150x100>", :thumb => "100x82>" },
                            :storage => (production ? :s3 : :filesystem),
                            :s3_credentials => "#{Rails.root}/config/s3.yml",
                            :path => (production ? ":attachment/:id/:style/:basename.:extension" : "public/system/:attachment/:id/:style/:basename.:extension"),
                            :bucket => $paperclip_bucket,
                            :default_url => "/images/missing.png"

  validates_attachment_size         :picture, :less_than => 10.megabytes, :message => "^El archivo debe ser menor a 10 MegaBytes"
  validates_attachment_content_type :picture, :content_type => ['image/jpeg','image/jpg','image/jpeg','image/pjpeg','image/png','image/x-png','image/gif'], 
                                              :message => "^Solo están permitidas las imágenes tipo JPEG, PNG y GIF."
  
  validates_presence_of   :name, :email, :party_id, :state_id
  validates_presence_of   :district_id, :if => :elected?
  
  validates_uniqueness_of :name, :unless => :is_importing?
  validates_uniqueness_of :email, :unless => :is_importing?
  
  scope :incomplete, where('complete = ?', false)
  scope :complete, where('complete = ?', true)
  scope :duplicate, where('duplicate = ?', true)
  scope :active, where('status = ?', 'active')
  scope :include_party, includes(:party)
  scope :name_like, lambda { |name| where("name #{$like} ?", "%#{name}%")}
  
  before_save :normalize_attributes
  before_validation :clean_twitter_user
  
  def self.present_in_sitting(sitting)
    where('assistances.sitting_id = ? AND assistances.assisted = ?', sitting.id, true).includes(:assistances)
  end
  
  def self.find_by_email_or_name(string)
    member = find_by_email(string)
    member = find_by_name(string) unless member
    return member
  end
  
  def is_importing?
    importing
  end
  
  def elected?
    self.election == "Mayoría Relativa"
  end
  
  def proportional?
    self.election == "Representación Proporcional"
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
  
  def district_number
    self.district.number if self.district
  end
  
  def district_number=(number)
    if self.state
      district = self.state.districts.find_by_number(number.to_i)
      write_attribute(:district_id, district.id) if district
    end
  end
  
  def self.create_from_csv(row)
    member = Member.new(:name => row['nombre'], 
                        :email => row['correo'],
                        :commission => row['comision'],
                        :state_name => row['entidad'],
                        :election => row['tipo_eleccion'],
                        :birthdate => row['fecha_nacimiento'],
                        :birthplace => row['lugar_nacimiento'],
                        :substitute => row['suplente'],
                        :party_abbr => row['partido'],
                        :curul => row['curul'],
                        :education => row['escolaridad'],
                        :political_experience => row['trayectoria_politica'],
                        :private_experience => row['iniciativa_privada'])
    member.district_number = row['distrito']
    member.importing = true
    member.complete = false unless member.valid?
    member.duplicate = true if member.same_name_or_email?
    member.save(false)
  end
  
  def same_name_or_email?
    member = Member.where("name = ? OR email = ?", self.name, self.email).first
    return member ? true : false
  end
  
  def normalize_attributes
    self.complete = true if self.valid?
    self.district_id = nil if self.proportional?
  end
  
  def clean_twitter_user
    self.twitter_user = read_attribute(:twitter_user).gsub(/@/, "")
  end
end
