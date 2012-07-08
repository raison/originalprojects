class RepliesController < ApplicationController
  before_filter :require_profile
  before_filter :load_comment

  def create
    @comment.replies.create(params[:reply].merge(:profile => current_profile))
    redirect_to project_url(@comment.project, :anchor => "comments")
  end

  private

  def load_comment
    @comment = Comment.find(params[:comment_id])
  end
end
