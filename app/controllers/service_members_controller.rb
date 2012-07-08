class ServiceMembersController < ApplicationController
  before_filter :require_profile
  before_filter :load_service
  before_filter :check_service_ownership
  before_filter :load_profile, :only => :create
  before_filter :load_service_membership, :only => [:destroy, :promote]
  before_filter :add_console
  before_filter :set_console_section
  before_filter :store_location, :only => :index

  def index
    render
  end

  def create
    service_membership = @service.add_participant(@profile)

    respond_to do |format|
      format.html { redirect_to service_members_url(@service) }
      format.js do
        if service_membership.valid?
          render :partial => "member", :locals => { :member => @profile, :service => @service }
        else
          render :nothing => true
        end
      end
    end
  end

  def destroy
    @service_membership.destroy
    redirect_to service_service_members_url(@service)
  end

  def promote
    @service_membership.update_attribute(:originator, true)
    redirect_to service_service_members_url(@service)
  end

  private

  def load_profile
    @profile = if params[:username]
      Profile.find_by_username(params[:username])
    else
      Profile.find(params[:member][:profile_id])
    end
  end

  def load_service_membership
    @service_membership = ServiceMembership.find_by_service_id_and_profile_id!(@service.id, params[:id])
  end

  def set_console_section
    @console_section = :services
  end
end
