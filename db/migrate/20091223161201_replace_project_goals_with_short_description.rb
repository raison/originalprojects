class ReplaceProjectGoalsWithShortDescription < ActiveRecord::Migration
  def self.up
    remove_column :projects, :goals
    add_column :projects, :short_description, :string, :null => false, :limit => 150
  end

  def self.down
    add_column :projects, :goals, :text
    remove_column :projects, :short_description
  end
end
