class AddAssistedDefaultToAssistances < ActiveRecord::Migration
  def self.up
    change_column_default :assistances, :assisted, false
  end

  def self.down
    change_column_default :assistances, :assisted, nil
  end
end
