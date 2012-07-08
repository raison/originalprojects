class Like < ActiveRecord::Base
  belongs_to :profile
  belongs_to :project

  validates_presence_of :profile
  validates_presence_of :project
  validates_uniqueness_of :profile_id, :scope => :project_id
end
