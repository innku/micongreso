class CreateSittings < ActiveRecord::Migration
  def self.up
    create_table :sittings do |t|
      t.string    :name
      t.datetime  :date
      t.timestamps
    end
  end
  
  def self.down
    drop_table :sittings
  end
end
