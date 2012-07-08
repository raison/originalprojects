class AddServiceownerToProfiles < ActiveRecord::Migration
  def self.up
  add_column :profiles, :serviceowner, :boolean, :null => false, :default => false
  end

  def self.down
  drop_table :serviceowner
  end
end
