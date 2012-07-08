class SessionsController < ApplicationController
  prepend_before_filter :require_https, :except => [:destroy]

  before_filter :require_no_profile, :only => [:new, :create]
  before_filter :require_profile, :only => :destroy

  before_filter :set_section

  def new
    full_width
    current_profile_session = ProfileSession.new
  end

  def create
    current_profile_session = ProfileSession.new(params[:profile_session])

    if current_profile_session.save
      flash[:notice] = "Login successful!"
      session[:return_to] = nil
      redirect_back_or_default dashboard_url
    else
      @errors = ['Invalid username or password']
      render :action => :new
    end
  end

  def destroy
    current_profile_session.destroy
    flash[:notice] = "Logout successful!"
    clear_session
    redirect_to root_url
  end

  private

  def set_section
    @section = "sign in"
  end
end
