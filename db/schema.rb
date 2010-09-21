# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100921013831) do

  create_table "assistances", :force => true do |t|
    t.integer  "sitting_id"
    t.integer  "member_id"
    t.boolean  "assisted",      :default => false
    t.boolean  "justified"
    t.text     "justification"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bills", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "member_votes_for",     :default => 0
    t.integer  "member_votes_against", :default => 0
    t.integer  "member_votes_neutral", :default => 0
    t.integer  "total_views",          :default => 0
    t.integer  "week_views",           :default => 0
    t.integer  "user_votes_for",       :default => 0
    t.integer  "user_votes_against",   :default => 0
    t.integer  "user_votes_neutral",   :default => 0
    t.date     "vote_date"
    t.string   "status",               :default => "pending"
    t.integer  "sitting_id"
    t.datetime "voted_on"
    t.integer  "member_id"
    t.text     "resolution"
    t.integer  "congress_id"
  end

  create_table "cities", :force => true do |t|
    t.string  "name"
    t.integer "state_id"
    t.string  "city_name"
    t.integer "priority"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.datetime "invited_on"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "districts", :force => true do |t|
    t.integer "number",   :null => false
    t.integer "state_id", :null => false
    t.string  "head"
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "commission"
    t.integer  "district_id"
    t.string   "election"
    t.date     "birthdate"
    t.string   "birthplace"
    t.string   "substitute"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size",    :default => 0
    t.datetime "picture_updated_at"
    t.integer  "party_id"
    t.integer  "state_id"
    t.boolean  "complete",             :default => true
    t.boolean  "duplicate",            :default => false
    t.string   "curul"
    t.text     "education"
    t.text     "political_experience"
    t.text     "private_experience"
    t.integer  "official_id"
    t.integer  "term_id"
    t.string   "status",               :default => "active"
    t.integer  "congress_id"
  end

  create_table "messages", :force => true do |t|
    t.text     "text"
    t.string   "name"
    t.string   "email"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "abstract"
    t.text     "body"
    t.date     "date"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size",    :default => 0
    t.datetime "photo_updated_at"
    t.integer  "views",              :default => 0
    t.integer  "congress_id"
  end

  create_table "notifications", :force => true do |t|
    t.boolean "email"
    t.boolean "twitter"
    t.boolean "facebook"
    t.boolean "sms"
    t.boolean "interest_topics"
    t.integer "user_id"
  end

  create_table "parties", :force => true do |t|
    t.string "name"
    t.string "abbr"
  end

  create_table "profiles", :force => true do |t|
    t.string   "political_views"
    t.string   "ocupation"
    t.string   "education"
    t.string   "marital_status"
    t.boolean  "sex"
    t.date     "birthdate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size",    :default => 0
    t.datetime "avatar_updated_at"
  end

  create_table "regions", :force => true do |t|
    t.integer "number", :null => false
  end

  create_table "resources", :force => true do |t|
    t.string  "name"
    t.string  "url"
    t.integer "bill_id"
  end

  create_table "search_members", :force => true do |t|
    t.string   "name"
    t.integer  "party_id"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", :force => true do |t|
    t.integer "number",      :null => false
    t.integer "district_id", :null => false
  end

  create_table "sittings", :force => true do |t|
    t.string   "name"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "term_id"
  end

  create_table "states", :force => true do |t|
    t.string  "name"
    t.string  "abbr"
    t.string  "short2"
    t.string  "short3"
    t.integer "region_id"
    t.string  "subdomain"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.string   "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "terms", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "congress_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name",              :limit => 100, :default => ""
    t.string   "email",             :limit => 100
    t.string   "crypted_password",  :limit => 128
    t.string   "salt",              :limit => 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.integer  "ife_state_id"
    t.integer  "city_id"
    t.integer  "section_id"
    t.integer  "congress_id"
    t.string   "activation_code",   :limit => 40
    t.string   "persistence_token"
    t.string   "perishable_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["role"], :name => "index_users_on_role"

  create_table "views", :force => true do |t|
    t.integer  "bill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "views", ["bill_id"], :name => "index_views_on_bill_id"

  create_table "votes", :force => true do |t|
    t.boolean  "vote"
    t.integer  "voteable_id",   :null => false
    t.string   "voteable_type", :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "fk_voteables"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "uniq_one_vote_only", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "fk_voters"

end
