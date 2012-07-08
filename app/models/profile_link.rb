class ProfileLink < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :profile, :url
end
