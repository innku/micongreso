class User < ActiveRecord::Base
  
  acts_as_authentic do |c|
    c.transition_from_restful_authentication = true
  end
  
  acts_as_voter
  acts_as_taggable
      
  belongs_to  :city
  belongs_to  :section
  belongs_to  :state,   :foreign_key => :ife_state_id
  has_one     :profile, :dependent => :destroy
  has_one     :notification, :dependent => :destroy
  has_many    :contacts, :dependent => :nullify
  
  validates_presence_of     :name
  
  validates_presence_of     :city_id, :if => :citizen?
  validate  :valid_district

  delegate :state, :to => :city
  delegate :district, :to => :section
  delegate :member, :to => :district

  scope :citizen, where("role = ?", 'citizen')
  scope :admin, where("role = ?", 'admin')
  scope :with_avatar, where('profiles.avatar_file_size > ?', 0).includes(:profile)
  scope :latest, order("users.created_at DESC").limit(21)
  
  before_create :build_profile_and_notification, :generate_activation_code
  
  accepts_nested_attributes_for :profile, :notification
  
  attr_accessible :name, :email, :password, :password_confirmation, :ife_state_id, :city_id, :section_id
  attr_accessible :congress_id, :city_name, :section_number, :tag_list, :notification_attributes, :profile_attributes
  
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
    number = number ? number.to_i : 0
    if self.city
      if number == 0
        write_attribute(:section_id, nil)
      else
        self.section = self.state.sections.find_by_number(number)
        write_attribute(:section_number, number)
      end
    end
  end
  
  def valid_district
    unless self.section_number.blank?
      errors.add(:section_id, "^No encontramos la sección no. #{self.section_number} en el estado de #{self.state.name}") unless self.section
    end
  end
  
  def self.last_admin?
    admins.count <= 1
  end
  
  def active?
    self.activation_code == nil
  end
  
  def activate!
    self.activation_code = nil
    self.save
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
  
  def update_or_create_vote(voteable, vote_choice)
    vote_object = self.vote_object(voteable)
    if vote_object
      vote_object.update_attributes(:vote => vote_choice)
    else
      vote_object = self.vote(voteable, vote_choice)
    end
    return vote_object
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
  
  def generate_activation_code
    self.activation_code = Authlogic::Random.friendly_token
  end
  
  def build_profile_and_notification
    self.build_profile
    self.build_notification
  end

end
