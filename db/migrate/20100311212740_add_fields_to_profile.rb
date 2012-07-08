class AddFieldsToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :education, :text
    add_column :profiles, :employment, :text
    add_column :profiles, :hobbies, :text
    add_column :profiles, :skills, :text
    add_column :profiles, :pastproj, :text
    add_column :profiles, :originalproj, :text

  end

  def self.down
    remove_column :profiles, :education
    remove_column :profiles, :employment
    remove_column :profiles, :hobbies
    remove_column :profiles, :skills
    remove_column :profiles, :pastproj
    remove_column :profiles, :originalproj
end
end