class AddStatusToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :status, :string, :default => "active"
    
    Member.all.each do |member|
      member.status = "active"
      member.save
    end
  end

  def self.down
    remove_column :members, :status
  end
end
