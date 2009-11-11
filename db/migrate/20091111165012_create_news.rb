class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.string  :title
      t.text    :abstract
      t.text    :body
      t.date    :date
      t.string  :source
      t.timestamps
    end
  end
  
  def self.down
    drop_table :news
  end
end
