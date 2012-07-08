class CommentsController < ApplicationController
  before_filter :require_profile
  before_filter :load_project

  def create
    @project.comments.create(params[:comment].merge(:profile => current_profile))
    redirect_to project_url(@project, :anchor => "comments")
  end
end
