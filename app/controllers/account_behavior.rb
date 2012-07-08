module AccountBehavior
  def self.included(base)
    base.module_eval do
      filter_parameter_logging :password, :password_confirmation
      helper_method :current_profile_session, :current_profile, :logged_in?
    end
  end

  private

  def current_profile_session
    return @current_profile_session if defined?(@current_profile_session)
    @current_profile_session = ProfileSession.find
  end

  def current_profile
    return @current_profile if defined?(@current_profile)
    @current_profile = current_profile_session && current_profile_session.profile
  end

  alias_method :logged_in?, :current_profile

  def require_profile
    @profile = current_profile and return if current_profile
    
    store_location
    flash[:notice] = "You must be signed in to access this page"
    redirect_to login_url
    return false
  end
  
  def require_no_profile
    if current_profile
      store_location
      flash[:notice] = "You must be signed out to access this page"
      redirect_to dashboard_url
      return false
    end
  end
end
