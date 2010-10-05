class News < ActiveRecord::Base
  
  belongs_to  :congress, :class_name => "State"
  
  cattr_reader :per_page
  @@per_page = 10
  
  validates_presence_of :title, :abstract, :body
  
  acts_as_taggable
  acts_as_commentable
  acts_as_voteable
  
  production = Rails.env.production?
  
  has_attached_file :photo, :styles => { :medium => "360x240>", :small => "180x100#", :thumb => "80x50#" },
                            :storage => (production ? :s3 : :filesystem),
                            :s3_credentials => "#{Rails.root}/config/s3.yml",
                            :path => (production ? ":attachment/:id/:style/:basename.:extension" : "public/system/:attachment/:id/:style/:basename.:extension"),
                            :bucket => $paperclip_bucket,
                            :default_url => "/images/missing_news.png"

  validates_attachment_size         :photo, :less_than => 10.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg','image/jpg','image/jpeg','image/pjpeg','image/png','image/x-png','image/gif']
  
  scope :ordered, order("created_at DESC")
  scope :latest, limit(5).order("created_at DESC")
  scope :popular, limit(5).order("views DESC")
  
  def self.title_or_body_like(query)
    where("title #{$like} ? OR body #{$like} ?", "%#{query}%", "%#{query}%")
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
  
  def citizen_votes(vote)
    Vote.joins("INNER JOIN users ON users.id = votes.voter_id").
        where("voteable_id = ? AND voteable_type = ? AND vote = ? AND voter_type = ?", self.id, self.class.name, vote, "User").count
  end
  
  def self.read_new_feed
    feed = Feedzirra::Feed.fetch_and_parse("http://www3.diputados.gob.mx/camara/rss/feed/Noticias.xml")
    create_news_from_feed(feed.entries, "Cámara de Diputados")
  end
  
  def self.update_feeds
    feed = Feedzirra::Feed.fetch_and_parse("http://www3.diputados.gob.mx/camara/rss/feed/Noticias.xml")
    updated_feed = Feedzirra::Feed.update(feed)
    
    create_news_from_feed(updated_feed.new_entries, "Cámara de Diputados")
  end
  
  def viewed!
    self.views += 1
    self.save
  end
  
  private
  def self.create_news_from_feed(entries, tags="")
    for entry in entries
      news = News.new
      news.title = entry.title
      news.abstract = entry.summary.strip.gsub(/<\/?[^>]*>/, "")[0,295] << "..."
      news.body = entry.summary
      news.date = Date.today
      news.tag_list = tags
      news.save
    end
  end
  
end
