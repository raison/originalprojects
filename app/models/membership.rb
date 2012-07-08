class Membership < ActiveRecord::Base
  belongs_to :profile
  belongs_to :project

  
  validates_presence_of :profile
  validates_presence_of :project

  validates_uniqueness_of :profile_id, :scope => :project_id 

  after_create :add_follower

  private

  def add_follower
    self.project.interests.create(:profile => self.profile)
  end
end
