class ServicesController < ApplicationController
uses_tiny_mce(:options => AppConfig.default_mce_options, :only => [:new, :edit, :index, :create])
  before_filter :require_profile, :except => [ :index, :show ]
  before_filter :load_service, :only => [ :show, :edit, :update, :follow, :join ]
  before_filter :check_service_ownership, :only => [ :edit, :update ]
  before_filter :add_console, :except => [ :index, :show ]
  before_filter :set_console_section, :except => [ :index, :show ]
  before_filter :store_location, :only => [ :index, :show ]

  def index
      sort = case params['sort']
           #when ""  then "featured DESC, title ASC"
           #when "a-z"  then "featured DESC, title ASC"
           #when "z-a"  then "featured DESC, title DESC"
           #when "location"   then "featured DESC, location ASC"
           #when "category" then "featured DESC, category ASC"
 
           when ""  then "title ASC"
           when "a-z"  then "title ASC"
           when "z-a"  then "title DESC"
           when "location"   then "location ASC"
           when "category" then "category ASC, title ASC"
                     
           end
           if !params['sort']
           	#sort = "featured DESC, title ASC"
           	sort = "title ASC"
           	end

    @section = "services"

    page = params[:page] || 1
    category = params[:category]
    if params[:category] == "" || !params[:category]
    	category = "All"
    	end
    if category == "All"
    	@services = Service.paginate :page => params[:page], :order => sort, :per_page => 5
    		else
    	@services = Service.paginate :page => params[:page], :conditions => "category = '#{category}'", :order => sort, :per_page => 5
    		end
    	
    @categories = Category.all
  end

  def show
    respond_to do |format|
      format.html do
        @sidebar = { :partial => "services/sidebar", :locals => { :project => @project } }
      end
      #format.atom do
      #  @activities = Activity.for_service(@project).latest(10)
      #end
    end
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(params[:service])

    if @service.save
      @service.service_memberships.create(:profile => current_profile, :originator => true)
      redirect_to dashboard_path
    else
      add_form_error
      render :action => 'new'
    end
  end

  def edit
    render
  end

  def update
    if @service.update_attributes(params[:service])
      redirect_to dashboard_path
    else
      render :action => :edit
    end
  end

  def my_services
    @services = current_profile.services_by_type
    
  end

  def follow
    current_profile.follow_service(@service)
    redirect_to :back
  end

  def join
    current_profile.join_service(@service)
    redirect_to :back
  end

  # AJAX endpoint

  def slug_check
    slug = params[:title].to_slug
    render :json => {:slug => slug, :unique => Service.count(:conditions => ['slug = ?', slug]) == 0}
  end

  private

  def set_console_section
    @console_section = :services
  end
end
