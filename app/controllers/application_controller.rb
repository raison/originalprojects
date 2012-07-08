# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  helper_method :url_params
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AccountBehavior
  include SslBehavior
  include MessagesBehavior

  rescue_from ActiveRecord::RecordNotFound do
    render :status => 404, :template => 'shared/404'
  end

  private

  def full_width
    @envelope_class = %w(full_width)
    @show_sidebar = false
  end

  def load_project
    project_id = params[:project_id] || params[:id]
    @project = if project_id =~ /^\d+$/
      Project.find(project_id)
    else
      Project.find_by_slug!(project_id)
    end

    if @project.public?
      @project
    else
      check_membership
    end
  end
  
    def load_service
    service_id = params[:service_id] || params[:id]
    @service = if service_id =~ /^\d+$/
      Service.find(service_id)
    else
      Service.find_by_slug!(service_id)
    end

    if @service.public?
      @service
    else
      check_service_membership
    end
  end


  def check_ownership
    if logged_in? && @project.originators.include?(current_profile)
      @project
    else
      render :status => 401, :nothing => true
    end
  end

  def check_membership
    if logged_in? && @project.profiles.include?(current_profile)
      @project
    else
      render :status => 401, :nothing => true
    end
  end
  
    def check_service_ownership
    if logged_in? && @service.originators.include?(current_profile)
      @service
    else
      render :status => 401, :nothing => true
    end
  end

  def check_service_membership
    if logged_in? && @service.profiles.include?(current_profile)
      @service
    else
      render :status => 401, :nothing => true
    end
  end

  def add_console
    @console = true
    @section = :dashboard
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    return_to = session[:return_to]
    clear_session
    redirect_to(return_to || default)
  end

  def clear_session
    session[:return_to] = nil
  end
end
