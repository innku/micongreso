class CreateActions < ActiveRecord::Migration
  def self.up
    create_table :actions do |t|
      t.string :action_type
      t.date :date
      t.text :text
      t.integer :bill_id

      t.timestamps
    end
  end

  def self.down
    drop_table :actions
  end
end
