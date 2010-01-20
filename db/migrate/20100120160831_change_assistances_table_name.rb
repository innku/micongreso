class ChangeAssistancesTableName < ActiveRecord::Migration
  def self.up
    rename_table :assistances, :absences
  end

  def self.down
    rename_table :absences, :assistances
  end
end
