class BlogEntry < ActiveRecord::Base
  belongs_to :project
  belongs_to :profile
  has_many :remarks

  validates_presence_of :project
  validates_presence_of :profile
  validates_presence_of :title
  validates_presence_of :content

  default_scope :order => "blog_entries.created_at DESC"
end
