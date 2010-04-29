class ChangeAbsencesTableName < ActiveRecord::Migration
  def self.up
    drop_table :absences
    create_table :assistances, :force => true do |t|
      t.integer :sitting_id
      t.integer :member_id
      t.boolean :assisted
      t.boolean :justified
      t.text    :justification
      t.timestamps
    end
  end

  def self.down
    drop_table :assistances
    create_table "absences", :force => true do |t|
      t.integer  "sitting_id"
      t.integer  "member_id"
      t.boolean  "justified"
      t.text     "justification"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end
end
