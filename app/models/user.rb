require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  acts_as_voter
  acts_as_taggable
      
  belongs_to  :city
  belongs_to  :section
  belongs_to  :state,   :foreign_key => :ife_state_id
  has_one     :profile, :dependent => :destroy
  has_one     :notification, :dependent => :destroy
  has_many    :contacts, :dependent => :nullify
  
  validates_presence_of     :name,     :message => "^Por favor llene su nombre"
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email,    :message => "^Por favor ingrese su correo electrónico"
  validates_length_of       :email,    :within => 6..100, :allow_blank => true
  validates_uniqueness_of   :email,    :case_sensitive => false, :message => "^Ya existe un usuario registrado con ese correo, por favor escoga uno diferente."
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message, :allow_blank => true
  
  validates_presence_of     :city_id,  :message => "^Por favor seleccione una ciudad"
  validate  :valid_district

  delegate :state, :to => :city
  delegate :district, :to => :section
  delegate :member, :to => :district

  before_create :make_activation_code

  named_scope :citizens, :conditions => ['role = ?', 'citizen']
  named_scope :admins, :conditions => ['role = ?', 'admin']
  named_scope :with_avatar, :include => :profile, :conditions => ['profiles.avatar_file_size > ?', 0]
  named_scope :latest, :order => "users.created_at DESC", :limit => 21
  
  accepts_nested_attributes_for :profile, :notification
  
  def city_name
    self.city.full_name if self.city
  end
  
  def city_name=(city_string)
    self.city = City.find_by_full_name(city_string).first
  end
  
  def section_number
    if read_attribute(:section_number)
      read_attribute(:section_number)
    elsif self.section
      self.section.number
    end
  end
  
  def section_number=(number)
    if self.city
      RAILS_DEFAULT_LOGGER.debug "state: #{state.id}, section: #{number}"
      if number.blank?
        write_attribute(:section_id, nil)
      else
        self.section = self.state.sections.find_by_number(number)
        write_attribute(:section_number, number)
      end
    end
  end
  
  def valid_district
    RAILS_DEFAULT_LOGGER.debug "Section: #{section.inspect}, section_number #{self.section_number}"
    unless self.section_number.blank?
      RAILS_DEFAULT_LOGGER.debug "Agregar error a section_id"
      errors.add(:section_id, "^No encontramos la sección no. #{self.section_number} en el estado de #{self.state.name}") unless self.section
    end
  end
  
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end
  
  def admin?
    role == "admin"
  end
  
  def citizen?
    role == "citizen"
  end
  
  def make_citizen
    self.role = "citizen"
  end
  
  def notify_me?(tags)
    if email
      if self.notification.interest_topics
        tags.each {|tag| return true if self.tags.include?(tag)}
      else
        return true
      end
    end
    return false
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def self.authenticate_inactive(email, password)
    return nil if email.blank? || password.blank?
    u = find :first, :conditions => ['email = ? and activated_at IS NULL', email]
    u && u.authenticated?(password) ? u : nil
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def generate_new_password!
    new_password = User.smart_password
    self.password = new_password
    self.password_confirmation = new_password
    self.save
    return new_password
  end
  
  def self.smart_password(size = 6)
    consonants = %w(b c d f g h j k l m n p qu r s t v w x z cr fr ch sp tr)
    vocals = %w(a e i o u y)
    f, pass = true, ''

    (size).times do
      pass << (f ? consonants[rand * consonants.size] : vocals[rand * vocals.size])
      f = !f
    end
    return pass
  end
  
  def before_create
    self.build_profile
    self.build_notification
  end

  protected
    
    def make_activation_code
        self.activation_code = self.class.make_token
    end

end
