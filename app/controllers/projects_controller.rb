class ProjectsController < ApplicationController
  before_filter :require_profile, :except => [ :index, :show ]
  before_filter :load_project, :only => [ :show, :edit, :update, :follow, :join ]
  before_filter :check_ownership, :only => [ :edit, :update ]
  before_filter :add_console, :except => [ :index, :show ]
  before_filter :set_console_section, :except => [ :index, :show ]
  before_filter :store_location, :only => [ :index, :show ]

  def index
    @section = "projects"
    @projects = Project.visible.by_title
  end

  def show
    respond_to do |format|
      format.html do
        @sidebar = { :partial => "projects/sidebar", :locals => { :project => @project } }
      end
      format.atom do
        @activities = Activity.for_project(@project).latest(10)
      end
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])

    if @project.save
      @project.memberships.create(:profile => current_profile, :originator => true)
      redirect_to dashboard_path
    else
      add_form_error
      render :action => 'new'
    end
  end

  def edit
    render
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to dashboard_path
    else
      render :action => :edit
    end
  end

  def my_projects
    @projects = current_profile.projects_by_type
  end

  def follow
    current_profile.follow_project(@project)
    redirect_to :back
  end

  def join
    current_profile.join_project(@project)
    redirect_to :back
  end

  # AJAX endpoint

  def slug_check
    slug = params[:title].to_slug
    render :json => {:slug => slug, :unique => Project.count(:conditions => ['slug = ?', slug]) == 0}
  end

  private

  def set_console_section
    @console_section = :projects
  end
end
