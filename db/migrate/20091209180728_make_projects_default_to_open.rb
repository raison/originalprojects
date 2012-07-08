class MakeProjectsDefaultToOpen < ActiveRecord::Migration
  def self.up
    change_column :projects, :membership_status, :string, :null => false, :default => "open"
  end

  def self.down
    change_column :projects, :membership_status, :string, :null => true, :default => nil
  end
end
