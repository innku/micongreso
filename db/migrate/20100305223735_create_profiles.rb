class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :political_views
      t.string :ocupation
      t.string :education
      t.string :marital_status
      t.boolean :sex
      t.date :birthdate
      t.timestamps
    end
  end
  
  def self.down
    drop_table :profiles
  end
end
