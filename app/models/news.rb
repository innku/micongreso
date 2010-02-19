require 'feedzirra'

class News < ActiveRecord::Base
  
  validates_presence_of :title, :message => "^Te faltó el título"
  validates_presence_of :abstract, :message => "^Te faltó el resumen"
  validates_presence_of :body, :message => "^Te faltó el cuerpo de la noticia"
  
  acts_as_taggable
  acts_as_commentable
  acts_as_voteable
  
  production = ENV['RAILS_ENV'] == 'production'
  
  has_attached_file :photo, :styles => { :medium => "360x240>", :thumb => "150x100>" },
                            :storage => (production ? :s3 : :filesystem),
                            :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                            :path => (production ? ":attachment/:id/:style/:basename.:extension" : "public/system/:attachment/:id/:style/:basename.:extension"),
                            :bucket => $paperclip_bucket

  validates_attachment_size         :photo, :less_than => 10.megabytes, :message => "^El archivo debe ser menor a 10 MegaBytes"
  validates_attachment_content_type :photo, :content_type => ['image/jpeg','image/jpg','image/jpeg','image/pjpeg','image/png','image/x-png','image/gif'], 
                                              :message => "^Solo están permitidas las imágenes tipo JPEG, PNG y GIF."
  
  named_scope :latest, :limit => 5, :order => "created_at DESC"
  
  
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
    Vote.count(:all, :joins => "INNER JOIN users ON users.id = votes.voter_id",
                      :conditions => ["voteable_id = ? AND voteable_type = ? AND vote = ? AND voter_type = ?", self.id, self.class.name, vote, "User"])
  end
  
  def self.read_new_feed
    feed = Feedzirra::Feed.fetch_and_parse("http://www3.diputados.gob.mx/camara/rss/feed/Noticias.xml")
    create_news_from_feed(feed.entries, "Cámara de Diputados")
  end
  
  def self.update_feeds
    feed = Feedzirra::Feed.fetch_and_parse("http://www3.diputados.gob.mx/camara/rss/feed/Noticias.xml")
    updated_feed = Feedzirra::Feed.update(feed)
    
    RAILS_DEFAULT_LOGGER.debug "Se actualizo? #{updated_feed.updated?}"
    RAILS_DEFAULT_LOGGER.debug "Nuevas entradas: #{updated_feed.new_entries.inspect}"
    
    create_news_from_feed(updated_feed.new_entries, "Cámara de Diputados")
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
