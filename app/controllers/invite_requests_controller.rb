class InviteRequestsController < ApplicationController
  before_filter :set_section
  before_filter :full_width

  def new
    @invite_request = InviteRequest.new
  end

  def create
    @invite_request = InviteRequest.new(params[:invite_request])
    if @invite_request.save
    @invite_request.send_invite
      add_notice "Please check your email to finish creating your account."
      redirect_to root_url
    else
      render :new
    end
  end

  private

  def set_section
    @section = "request invite"
  end
end
