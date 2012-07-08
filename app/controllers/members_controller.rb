class MembersController < ApplicationController
  before_filter :require_profile
  before_filter :load_project
  before_filter :check_ownership
  before_filter :load_profile, :only => :create
  before_filter :load_membership, :only => [:destroy, :promote]
  before_filter :add_console
  before_filter :set_console_section
  before_filter :store_location, :only => :index

  def index
    render
  end

  def create
    membership = @project.add_participant(@profile)

    respond_to do |format|
      format.html { redirect_to project_members_url(@project) }
      format.js do
        if membership.valid?
          render :partial => "member", :locals => { :member => @profile, :project => @project }
        else
          render :nothing => true
        end
      end
    end
  end

  def destroy
    @membership.destroy
    redirect_to project_members_url(@project)
  end

  def promote
    @membership.update_attribute(:originator, true)
    redirect_to project_members_url(@project)
  end

  private

  def load_profile
    @profile = if params[:username]
      Profile.find_by_username(params[:username])
    else
      Profile.find(params[:member][:profile_id])
    end
  end

  def load_membership
    @membership = Membership.find_by_project_id_and_profile_id!(@project.id, params[:id])
  end

  def set_console_section
    @console_section = :projects
  end
end
