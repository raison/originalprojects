class ProfilesController < ApplicationController
  prepend_before_filter :require_https, :except => [:show, :logout]
  before_filter :require_profile, :except => [:new, :create, :index, :show]
  before_filter :add_console, :only => [:edit, :update]
  before_filter :set_console_section, :only => [ :edit, :show, :update ]

  def index
    render :json => Profile.search_username_and_email(params[:val]).map(&:username)
  end

  def new
    @new_profile = Profile.new
  end

  def show
    if params[:id]
      @profile = Profile.find(params[:id])
    elsif logged_in?
      add_console
      add_notice('This is how your profile currently appears. <a href="/my_profile/edit">Edit your profile...</a>', :now => true)
      @profile = current_profile
    end
    
    @originated_projects = @profile.originated_projects.visible
    @collaborating_projects = @profile.member_projects.visible
    @followed_projects = @profile.followed_projects.visible - @profile.originated_projects
  end

  def create
    @new_profile = Profile.register(params[:new_profile],
                                params[:invite_token])
    if @new_profile.new_record?
      render :action => 'new'
    else
      add_notice render_to_string(:partial => "welcome_message")
      #redirect_to profiles_path
      redirect_to :action => "edit"

    end
  end

  def edit
    render
  end

  def update
    if current_profile.update_attributes(params[:profile])
      add_notice 'Settings have been saved'
      redirect_to dashboard_path
    else
      add_form_error
      render :action => 'edit'
    end
  end

  private

  def set_console_section
    @console_section = :profile
  end
end
