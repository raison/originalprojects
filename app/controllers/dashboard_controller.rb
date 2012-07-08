class DashboardController < ApplicationController
  before_filter :require_profile
  before_filter :add_console

  def show
    @console_section = :dashboard
    @projects = current_profile.projects_by_type
    @activity = Activity.for_projects(current_profile.followed_projects).latest(50)
    render
  end

  [:inbox, :network, :store, :settings].each do |section|
    define_method section do
      @console_section = section
      render
    end
  end
end
