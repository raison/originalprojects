class Remark < ActiveRecord::Base
  belongs_to :blog_entry
  belongs_to :profile

  validates_presence_of :blog_entry
  validates_presence_of :profile
  validates_presence_of :content
end
