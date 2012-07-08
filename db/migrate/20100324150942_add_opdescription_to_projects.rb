class AddOpdescriptionToProjects < ActiveRecord::Migration
  def self.up
  add_column :projects, :opdescription, :text
  end

  def self.down
  remove_column :projects, :opdescription
  end
end
