class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text    :text
      t.string  :name
      t.string  :email
      t.integer :member_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :messages
  end
end
