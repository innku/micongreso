class RemoveAssistedFromAbsences < ActiveRecord::Migration
  def self.up
    remove_column :absences, :assisted
  end

  def self.down
    add_column :absences, :assisted, :boolean
  end
end
