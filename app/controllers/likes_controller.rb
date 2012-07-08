class LikesController < ApplicationController
  before_filter :require_profile
  before_filter :load_project

  def create
    @project.likes.create(:profile => current_profile)
    redirect_to @project
  end

  def destroy
    like = @project.likes.find(params[:id])

    if like.profile == current_profile
      like.destroy
      redirect_to @project
    else
      render :status => 401, :nothing => true
    end
  end
end
