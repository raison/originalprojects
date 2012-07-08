class ServiceMembershipRequestsController < ApplicationController
  before_filter :require_profile
  before_filter :load_service
  before_filter :check_ownership, :only => :destroy

  def create
    mr = @service.membership_requests.build(:profile => current_profile)
    add_error(mr.errors.full_messages) unless mr.save
    redirect_to @service
  end

  def destroy
    @service.membership_requests.find(params[:id]).destroy
    redirect_to service_members_url(@service)
  end
end