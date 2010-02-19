class Bill < ActiveRecord::Base  
    
  has_many  :views
  
  validates_presence_of :name, :message => "^Te faltó el título de la propuesta"
  validates_presence_of :description, :message => "^Te faltó la descripción de la propuesta"
  
  attr_accessor :publish_bill_on_social_media
  attr_accessor :send_emails
  
  acts_as_taggable
  acts_as_voteable
  
  named_scope :latest_voted, :conditions => ["member_votes_for != ? OR member_votes_against != ? OR member_votes_neutral != ?",0,0,0], :order => "created_at DESC"
  
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
                      :conditions => ["voteable_id = ? AND voteable_type = ? AND vote = ? AND voter_type = ?", self.id, self.class.name, vote, "User"])
  end
  
  def update_week_views!
    self.week_views = self.views.last_week.count
    self.save
  end

  def after_save
    if publish_bill_on_social_media.to_i == 1
      PingFM.post_to_social_media(self.name, "#{$global_url}/bills/#{self.id}")
    end
    
    if send_emails.to_i == 1
      User.citizens.each {|citizen| UserMailer.deliver_bill(citizen, self)}
    end
  end
  
end
