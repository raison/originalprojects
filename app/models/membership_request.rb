class MembershipRequest < ActiveRecord::Base
  belongs_to :project
  belongs_to :profile

  validates_presence_of :project
  validates_presence_of :profile
  validates_uniqueness_of :profile_id, :scope => :project_id
  validate :profile_not_participant
  validate :project_is_invite_only

  private

  def profile_not_participant
    if Membership.find_by_project_id_and_profile_id(self.project_id, self.profile_id)
      self.errors.add(:profile, "is already a member of this project")
    end
  end

  def project_is_invite_only
    if self.project && self.project.membership_status != Project::MEMBERSHIP_STATUS_INVITE
      self.errors.add(:project, "is not invite-only")
    end
  end
end
