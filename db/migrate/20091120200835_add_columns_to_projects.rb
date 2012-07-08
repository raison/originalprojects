class AddColumnsToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :needs, :text
    add_column :projects, :url, :string
  end

  def self.down
    remove_column :projects, :needs
    remove_column :projects, :url
  end
end
