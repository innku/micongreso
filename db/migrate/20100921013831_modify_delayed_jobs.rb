class ModifyDelayedJobs < ActiveRecord::Migration
  def self.up
    change_column :delayed_jobs, :locked_by, :string
    add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'  
  end
  
  def self.down
    remove_index :delayed_jobs, :name => :delayed_jobs_priority  
    change_column :delayed_jobs, :locked_by, :text
  end
end