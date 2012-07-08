class BlogEntriesController < ApplicationController
uses_tiny_mce(:options => AppConfig.default_mce_options, :only => [:new, :edit, :index, :create])
  before_filter :require_profile
  before_filter :load_project
  before_filter :load_blog_entry, :only => [:edit, :update, :destroy]
  before_filter :check_ownership, :unless => proc { |c|
    c.request.parameters["action"] == "index" && c.request.xhr?
  }
  before_filter :add_console
  before_filter :set_console_section

  def index
    respond_to do |format|
      format.html
      format.js do
        render :partial => "projects/update", :collection => @project.blog_entries[5..-1]
      end
    end
  end

  def new
    @blog_entry = @project.blog_entries.build
  end

  def create
    @blog_entry = @project.blog_entries.build(params[:blog_entry])
    @blog_entry.profile = current_profile

    if @blog_entry.save
      add_notice "Blog entry posted! #{view_link}"
      redirect_to project_blog_entries_url
    else
      render :action => "new"
    end
  end

  def edit
    render
  end

  def update
    if @blog_entry.update_attributes(params[:blog_entry])
      add_notice "Changes to blog entry saved. #{view_link}"
      redirect_to project_blog_entries_url
    else
      render :action => "edit"
    end
  end

  def destroy
    @blog_entry.destroy
    add_notice "Blog entry deleted."
    redirect_to project_blog_entries_url
  end

  private

  def load_blog_entry
    @blog_entry = @project.blog_entries.find(params[:id])
  end

  def view_link
    "<a href=\"#{ project_url(@project, :anchor => "blog") }\">View now.</a>"
  end

  def set_console_section
    @console_section = :projects
  end
end
