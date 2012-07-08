class Reply < ActiveRecord::Base
  belongs_to :comment
  belongs_to :profile

  validates_presence_of :comment
  validates_presence_of :profile
  validates_presence_of :content
end
