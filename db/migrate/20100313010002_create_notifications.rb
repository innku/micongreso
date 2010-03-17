class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.boolean :email
      t.boolean :twitter
      t.boolean :facebook
      t.boolean :sms
      t.boolean :interest_topics
      t.integer :user_id
    end
  end
  
  def self.down
    drop_table :notifications
  end
end
