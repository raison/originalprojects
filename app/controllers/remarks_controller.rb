class RemarksController < ApplicationController
  before_filter :require_profile
  before_filter :load_project
  before_filter :load_entry

  def create
    @blog_entry.remarks.create(params[:remark].merge(:profile => current_profile))
    redirect_to project_url(@blog_entry.project, :anchor => "blog")
  end

  private

  def load_entry
    @blog_entry = @project.blog_entries.find(params[:blog_entry_id])
  end
end
