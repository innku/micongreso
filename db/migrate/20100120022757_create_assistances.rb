class CreateAssistances < ActiveRecord::Migration
  def self.up
    create_table :assistances do |t|
      t.integer     :sitting_id
      t.integer     :member_id
      t.boolean     :assisted
      t.boolean     :justified
      t.text        :justification
      t.timestamps
    end
  end
  
  def self.down
    drop_table :assistances
  end
end
