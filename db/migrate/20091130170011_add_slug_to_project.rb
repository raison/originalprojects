class AddSlugToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :slug, :string, :null => false, :unique => true
    
    Project.find_each do |p| 
      p.slug = p.title.try( :to_slug )
      p.save!
    end
  end

  def self.down
    remove_column :projects, :slug
  end
end
