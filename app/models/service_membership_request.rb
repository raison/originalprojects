class ServiceMembershipRequest < ActiveRecord::Base
  belongs_to :service
  belongs_to :profile

  validates_presence_of :service
  validates_presence_of :profile
  validates_uniqueness_of :profile_id, :scope => :service_id
  validate :profile_not_participant
  validate :service_is_invite_only

  private

  def profile_not_participant
    if Service_membership.find_by_service_id_and_profile_id(self.service_id, self.profile_id)
      self.errors.add(:profile, "is already a member of this service")
    end
  end

  def service_is_invite_only
    if self.service && self.service.membership_status != Service::MEMBERSHIP_STATUS_INVITE
      self.errors.add(:service, "is not invite-only")
    end
  end
end