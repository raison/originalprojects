class DropProfileProjects < ActiveRecord::Migration
  class ProfileProject < ActiveRecord::Base
    belongs_to :project
    belongs_to :profile
  end

  def self.up
    puts "ProfileProjects: #{ProfileProject.count}"

    ProfileProject.all.each do |pp|
      project, profile = [pp.project, pp.profile]

      case pp.role
      when "originator"
        project.memberships.create(:profile => profile, :originator => true)
      when "member"
        project.members << profile
      when "follower"
        project.followers << profile
      end
    end

    puts "Memberships: #{Membership.count}, Followers: #{Interest.count}"

    drop_table :profile_projects
  end

  def self.down
    create_table :profile_projects, :force => true do |t|
      t.references :profile, :null => false, :foreign_key => true
      t.references :project, :null => false, :foreign_key => true
      t.string     :role,    :null => false
      t.timestamps
    end

    Membership.all.each do |membership|
      pp = ProfileProject.new
      pp.project = membership.project
      pp.profile = membership.profile
      pp.role = (membership.originator? ? "originator" : "member")
      pp.save!
      membership.destroy
    end

    Interest.all.each do |interest|
      pp = ProfileProject.new
      pp.project = interest.project
      pp.profile = interest.profile
      pp.role = "follower"
      pp.save!
      interest.destroy
    end
  end
end
