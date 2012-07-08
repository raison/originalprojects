class Comment < ActiveRecord::Base
  belongs_to :project
  belongs_to :profile
  has_many :replies

  validates_presence_of :project
  validates_presence_of :profile
  validates_presence_of :content

  default_scope :order => "comments.created_at DESC"

  named_scope :by_originators,
    :joins => "JOIN memberships ON (memberships.profile_id = comments.profile_id " +
      "AND memberships.project_id = comments.project_id)",
    :conditions => ["memberships.originator = ?", true]
end
