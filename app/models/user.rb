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
  
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  validates_presence_of     :city_id,  :message => "^Por favor seleccione una ciudad"

  before_create :make_activation_code

  named_scope :citizens, :conditions => ['role = ?', 'citizen']
  named_scope :admins, :conditions => ['role = ?', 'admin']
  
  accepts_nested_attributes_for :profile, :notification
  
  def city_name
    self.city.full_name if self.city
  end
  
  def city_name=(city_string)
    self.city = City.find_by_full_name(city_string).first
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
    if self.notification.interest_topics
      tags.each {|tag| return true if self.tags.include?(tag)}
    else
      return true
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
  
  def before_create
    self.build_profile
    self.build_notification
  end

  protected
    
    def make_activation_code
        self.activation_code = self.class.make_token
    end


end
