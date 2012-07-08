class PasswordsController < ApplicationController
  before_filter :load_profile_from_token, :only => [:show, :update]
  before_filter :set_section
  before_filter :full_width

  def new
    render
  end

  def create
    profile = Profile.find_by_email(params[:email])

    if profile
      profile.deliver_password_reset_instructions
      add_notice "Check your email for instructions for resetting your password."
      redirect_to new_password_url
    else
      add_error "We could not find a profile matching that email address.", :now => true
      render :action => :new
    end
  end

  def show
    render
  end

  def update
    if @profile.update_attributes(params[:profile])
      redirect_to root_url
    else
      render :action => :show
    end
  end

  private

  def load_profile_from_token
    @profile = Profile.find_using_perishable_token(params[:id])

    if @profile.nil?
      add_notice "We couldn't find your account. " +
        "Your reset window might have expired, or you could have followed a bad link."
      redirect_to new_password_url
    end
  end

  def set_section
    @section = :dashboard
  end
end
