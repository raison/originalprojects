class ServiceInterest < ActiveRecord::Base
  belongs_to :profile
  belongs_to :service

  validates_presence_of :profile
  validates_presence_of :service
  validates_uniqueness_of :profile_id, :scope => :service_id
end