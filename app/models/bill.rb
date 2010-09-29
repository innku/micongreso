class Bill < ActiveRecord::Base  
    
  has_many  :views, :dependent => :destroy
  has_many  :resources, :dependent => :destroy
  has_many  :actions
  belongs_to  :sitting
  belongs_to  :sponsor, :class_name => "Member", :foreign_key => "member_id"
  belongs_to  :congress, :class_name => "State"
  
  validates_presence_of :name, :description
  
  attr_accessor :publish_bill_on_social_media
  attr_accessor :send_emails
  
  acts_as_taggable
  acts_as_voteable
  acts_as_commentable
  
  accepts_nested_attributes_for :resources, :reject_if => proc { |a| a[:url].blank? }, :allow_destroy => true
  
  scope :voted, where("member_votes_for != ? OR member_votes_against != ? OR member_votes_neutral != ?",0,0,0).order("created_at DESC")
  scope :recent, order("created_at DESC")
  scope :most_viewed, order("total_views DESC")
  scope :pending, where('status = ?', 'pending')
  
  after_save :publish_bill, :deliver_emails
  
  def self.name_or_description_like(query)
    where("name #{$like} ? OR description #{$like} ?", "%#{query}%", "%#{query}%")
  end
  
  def self.recent_popular
    last_month.most_viewed
  end
  
  def self.last_month
    where('created_at >= ?', Date.today-1.months)
  end
  
  def self.monthly(month, year)
    month_selector = Rails.env.production? ? "EXTRACT(MONTH FROM bills.created_at)" : "MONTH(bills.created_at)"
    year_selector = Rails.env.production? ? "EXTRACT(YEAR FROM bills.created_at)" : "YEAR(bills.created_at)"
    where("#{month_selector} = ? AND #{year_selector} = ?", month, year)
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
    self.status == "closed"
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
    self.save
  end
  
  def update_users_votes_count!(vote)
    if vote
      self.user_votes_for += 1
    else
      self.user_votes_against += 1
    end
    self.save!
  end
  
  def sponsor_name
    self.sponsor.name if self.sponsor
  end
  
  def sponsor_name=(string)
    self.sponsor = Member.find_by_name(string)
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
    Vote.joins("INNER JOIN members ON members.id = votes.voter_id").
          where("voteable_id = ? AND voteable_type = ? AND vote #{vote_sql(vote)} AND voter_type = ? AND members.party_id = ?", self.id, self.class.name, "Member", party.id).count
  end
  
  def votes_for_state(state, vote)
    Vote.joins("INNER JOIN members ON members.id = votes.voter_id").
          where("voteable_id = ? AND voteable_type = ? AND vote #{vote_sql(vote)} AND voter_type = ? AND members.state_id = ?", self.id, self.class.name, "Member", state.id).count
  end
  
  def citizen_votes(vote)
    Vote.joins("INNER JOIN users ON users.id = votes.voter_id").
           where("voteable_id = ? AND voteable_type = ? AND vote #{vote_sql(vote)} AND voter_type = ?", self.id, self.class.name, "User").count
  end
  
  def citizen_votes_for_state(state, vote)
    Vote.from("(votes").joins("INNER JOIN users ON users.id = votes.voter_id) INNER JOIN cities ON cities.id = users.city_id").
           where("voteable_id = ? AND voteable_type = ? AND vote #{vote_sql(vote)} AND voter_type = ? AND cities.state_id = ?", self.id, self.class.name, "User", state.id).count
  end
  
  def citizens_for_rate
    (self.user_votes_for.to_f/self.total_citizen_votes.to_f)*100
  end
  
  def total_citizen_votes
    self.user_votes_for + self.user_votes_against + self.user_votes_neutral
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
  
  def latest_action
    self.actions.last if self.actions.any?
  end
  
  def deliver
    User.citizens.each do |user|
      UserMailer.bill(user, self).deliver if user.notify_me?(self.tags)
    end
  end
  
  def test_deliver
    user = User.find_by_email("fedegl@gmail.com")
    UserMailer.bill(user, self).deliver if user.notify_me?(self.tags)
  end
  
  def test
    if Rails.env.production?
      heroku = Heroku::Client.new("federico@innku.com", "ziggy1304")
      heroku.set_workers("diputadovirtual", 1)
      #heroku.rake("diputadovirtual", "jobs:work")
    end
    self.send_later(:test_deliver)
  end

  def publish_bill
    if publish_bill_on_social_media.to_i == 1
      PingFM.post_to_social_media(self.name, "#{$global_url}/bills/#{self.id}")
    end
  end
    
  def deliver_emails
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
