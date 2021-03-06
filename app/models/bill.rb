class Bill < ActiveRecord::Base  
    
  has_many  :views, :dependent => :destroy
  has_many  :resources, :dependent => :destroy
  belongs_to  :sitting
  belongs_to  :member
  
  belongs_to  :congress, :class_name => "State"
  
  validates_presence_of :name, :message => "^Te faltó el título de la propuesta"
  validates_presence_of :description, :message => "^Te faltó la descripción de la propuesta"
  validates_presence_of :date, :message => "^Te faltó la fecha de presentación de la propuesta"
  
  attr_accessor :publish_bill_on_social_media
  attr_accessor :send_emails
  
  acts_as_taggable
  acts_as_voteable
  acts_as_commentable
  
  accepts_nested_attributes_for :resources, :reject_if => lambda { |a| a[:url].blank? }, :allow_destroy => true
  
  month_selector = Rails.env.production? ? "EXTRACT(MONTH FROM bills.date)" : "MONTH(bills.date)"
  year_selector = Rails.env.production? ? "EXTRACT(YEAR FROM bills.date)" : "YEAR(bills.date)"
  
  named_scope :voted, :conditions => ["member_votes_for != ? OR member_votes_against != ? OR member_votes_neutral != ?",0,0,0], :order => "created_at DESC"
  named_scope :recent, :order => "created_at DESC"
  named_scope :active, :conditions => ['vote_date >= ?', Date.today]
  named_scope :closed, :conditions => ['vote_date < ?', Date.today]
  named_scope :monthly, lambda { |*args| { :conditions => ["#{month_selector} = ? AND #{year_selector} = ?", args.first, args.last] } }
  named_scope :last_month, :conditions => ['date >= ?', Date.today-1.months]
  named_scope :most_viewed, :order => "total_views DESC"
  named_scope :limit, :limit => 5
  named_scope :pending, :conditions => ['status = ?', 'pending']
  named_scope :single_voted, :conditions => ['voted_on IS NOT NULL'], :order => "voted_on DESC"
  
  def self.recent_popular
    last_month.most_viewed
  end
  
  def approved?
    self.status == "approved"
  end
  
  def rejected?
    self.status == "rejected"
  end
  
  def pending?
    self.status == "pending"
  end
  
  def closed?
    return false if self.vote_date.nil?
    (self.vote_date < Date.today) && !self.pending?
  end
  
  def update_votes(params)
    if params
      params.each do |member_id, vote_value|      
        vote_value = vote_value.first.to_i
        vote_value = nil if vote_value == -1      
        member = Member.find(member_id.to_i)
        vote = member.vote_object(self)
        if vote
          vote.update_attributes(:vote => vote_value)
        else
          member.vote(self, vote_value)
        end
      end
    end
    self.member_votes_for = self.votes_for_by("Member")
    self.member_votes_against = self.votes_against_by("Member")
    self.member_votes_neutral = self.votes_neutral_by("Member")
    self.voted_on = Time.now
    self.save
  end
  
  def formatted_date
    if self.new_record?
      Date.today.to_s(:es)
    else
      read_attribute(:date).to_s(:es)
    end
  end
  
  def formatted_date=(date)
  end
  
  def formatted_vote_date
    if self.new_record?
      Date.today.to_s(:es)
    else
      read_attribute(:vote_date).to_s(:es) if read_attribute(:vote_date)
    end
  end
  
  def formatted_vote_date=(date)
  end
  
  def member_name
    self.member.name if self.member
  end
  
  def member_name=(string)
    self.member = Member.find_by_name(string)
  end
  
  def general_votes?
    (self.member_votes_for != 0) or (self.member_votes_against != 0) or (self.member_votes_neutral != 0)
  end
  
  def vote_sql(vote)
    vote_string = case vote
                  when true then "= true"
                  when false then "= false"
                  else "IS NULL"
                  end
    return vote_string
  end
  
  def votes_for_party(party, vote)
    Vote.count(:all, :joins => "INNER JOIN members ON members.id = votes.voter_id",
                      :conditions => ["voteable_id = ? AND voteable_type = ? AND vote #{vote_sql(vote)} AND voter_type = ? AND members.party_id = ?", self.id, self.class.name, "Member", party.id])
  end
  
  def votes_for_state(state, vote)
    Vote.count(:all, :joins => "INNER JOIN members ON members.id = votes.voter_id",
                      :conditions => ["voteable_id = ? AND voteable_type = ? AND vote #{vote_sql(vote)} AND voter_type = ? AND members.state_id = ?", self.id, self.class.name, "Member", state.id])
  end
  
  def citizen_votes(vote)
    Vote.count(:all, :joins => "INNER JOIN users ON users.id = votes.voter_id",
                      :conditions => ["voteable_id = ? AND voteable_type = ? AND vote #{vote_sql(vote)} AND voter_type = ?", self.id, self.class.name, "User"])
  end
  
  def citizen_votes_for_state(state, vote)
    Vote.count(:all, :from => "(votes", :joins => "INNER JOIN users ON users.id = votes.voter_id) INNER JOIN cities ON cities.id = users.city_id",
                      :conditions => ["voteable_id = ? AND voteable_type = ? AND vote #{vote_sql(vote)} AND voter_type = ? AND cities.state_id = ?", self.id, self.class.name, "User", state.id])
  end
  
  def citizen_votes_and_percents
    return @citizen_votes_and_percents_array if @citizen_votes_and_percents_array
    for_votes = user_votes_for
    against_votes = user_votes_against
    neutral_votes = user_votes_neutral
    total_votes = for_votes + against_votes + neutral_votes
    @citizen_votes_and_percents_array = [for_votes, against_votes, neutral_votes, (for_votes.to_f/total_votes)*100, (against_votes.to_f/total_votes)*100, (neutral_votes.to_f/total_votes)*100]
  end
  
  def member_votes_and_percents
    return @member_votes_and_percents_array if @member_votes_and_percents_array
    for_votes = member_votes_for
    against_votes = member_votes_against
    neutral_votes = member_votes_neutral
    total_votes = for_votes + against_votes + neutral_votes
    @member_votes_and_percents_array = [for_votes, against_votes, neutral_votes, (for_votes.to_f/total_votes)*100, (against_votes.to_f/total_votes)*100, (neutral_votes.to_f/total_votes)*100]
  end
  
  def update_week_views!
    self.week_views = self.views.last_week.count
    self.save
  end
  
  def deliver
    User.citizens.each do |citizen|
      UserMailer.deliver_bill(citizen, self) if citizen.notify_me?(self.tags)
    end
  end
  
  def test_deliver
    user = User.find_by_email("fedegl@gmail.com")
    UserMailer.deliver_bill(user, self) if user.notify_me?(self.tags)
  end
  
  def test
    if Rails.env.production?
      heroku = Heroku::Client.new("federico@innku.com", "ziggy1304")
      heroku.set_workers("diputadovirtual", 1)
      #heroku.rake("diputadovirtual", "jobs:work")
    end
    self.send_later(:test_deliver)
  end

  def after_save
    if publish_bill_on_social_media.to_i == 1
      PingFM.post_to_social_media(self.name, "#{$global_url}/bills/#{self.id}")
    end
    
    if send_emails.to_i == 1
      if Rails.env.production?
        heroku = Heroku::Client.new("federico@innku.com", "ziggy1304")
        heroku.set_workers("diputadovirtual", 1)
        #heroku.rake("diputadovirtual", "jobs:work")
      end
      self.send_later(:deliver)
    end
  end
  
end
