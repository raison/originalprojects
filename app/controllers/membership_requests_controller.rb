class MembershipRequestsController < ApplicationController
  before_filter :require_profile
  before_filter :load_project
  before_filter :check_ownership, :only => :destroy

  def create
    mr = @project.membership_requests.build(:profile => current_profile)
    add_error(mr.errors.full_messages) unless mr.save
    redirect_to @project
  end

  def destroy
    @project.membership_requests.find(params[:id]).destroy
    redirect_to project_members_url(@project)
  end
end
