class AddLocationToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :location, :string, :null => true
    
    count = 0
    
    Project.all.each do |project|
      unless project.originators.empty? or project.location.present?        
        project.location = project.originators.first.location
        count += 1 if project.save
      end
    end
    
    puts "Location updated for #{count} out of #{Project.count} projects."  
  end

  def self.down
    remove_column :projects, :location
  end
end
