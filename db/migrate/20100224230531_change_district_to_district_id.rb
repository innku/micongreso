class ChangeDistrictToDistrictId < ActiveRecord::Migration
  def self.up
    rename_column :members, :district, :district_id
  end

  def self.down
    rename_column :members, :district_id, :district
  end
end
