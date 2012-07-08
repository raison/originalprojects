ActionController::Routing::Routes.draw do |map|
  map.resources :categories

  
 map.resource :session, :only => [:new, :create, :destroy]
  map.with_options(:controller => 'sessions') do |session|
    session.login "/login", :action => 'new'
    session.logout "/logout", :action => 'destroy'
  end
  map.resources( :projects,
                 :collection => { :slug_check => :get },
                 :member => { :follow => :post, :join => :post }) do |project|
    project.resources :members, :member => { :promote => :post }
    project.resources :membership_requests
    project.resources :likes, :only => [:create, :destroy]
    project.resources :comments, :only => :create, :shallow => true do |comment|
      comment.resources :replies, :only => :create
    end
    project.resources :messages, :only => [:new, :create]
    project.resources :blog_entries, :except => :show do |blog_entry|
      blog_entry.resources :remarks, :only => :create
    end
  end

  map.with_options :controller => "images" do |project|
    project.edit_project_images("/projects/:project_id/images/edit",
                                :action => "edit",
                                :conditions => { :method => :get } )
    project.project_images(     "/projects/:project_id/images",
                                :action => "update",
                                :conditions => { :method => :put } )
  end

  map.my_projects( '/my_projects',
                   :controller => 'projects', :action => 'my_projects',
                   :conditions => { :method => :get } )
  
# services----------------------

                   
   map.resources( :services,
                 :collection => { :slug_check => :get },
                 :service_member => { :follow => :post, :join => :post }) do |service|
    service.resources :service_members, :service_member => { :promote => :post }
    service.resources :service_membership_requests
    service.resources :likes, :only => [:create, :destroy]
    service.resources :comments, :only => :create, :shallow => true do |comment|
      comment.resources :replies, :only => :create
    end
    service.resources :messages, :only => [:new, :create]
    service.resources :blog_entries, :except => :show do |blog_entry|
      blog_entry.resources :remarks, :only => :create
    end
  end

  map.with_options :controller => "images" do |service|
    service.edit_service_images("/services/:service_id/images/edit",
                                :action => "edit",
                                :conditions => { :method => :get } )
    service.service_images(     "/services/:service_id/images",
                                :action => "update",
                                :conditions => { :method => :put } )
  end
    map.my_services( '/my_services',
                   :controller => 'services', :action => 'my_services',
                   :conditions => { :method => :get } )
                 
  

             

#end services --------------------------------                   
                                     
                   
  map.connect 'attachments/create', :controller => 'attachments', :action => 'create'
  
  map.connect 'attachments/manage', :controller => 'attachments', :action => 'manage'                             

  map.resource( :invite_request,
                :only => [ :new, :create ] )

  map.request_invite( '/request_invite',
                      :controller => 'invite_requests',
                      :action => 'new' )


  map.dashboard( '/dashboard',
                 :controller => 'dashboard',
                 :action => :show,
                 :conditions => { :method => :get } )

  map.with_options(:controller => 'dashboard') do |dashboard|
    [:inbox, :network, :store, :settings].each do |section|
      dashboard.send(section, "/#{section}", :action => section)
    end
  end

  map.with_options(:controller => 'profiles') do |profile|
    profile.signup '/signup', :action => :new, :conditions => { :method => :get }
    profile.my_profile '/my_profile', :action => :show, :conditions => { :method => :get }
    profile.edit_profile '/my_profile/edit', :action => :edit, :conditions => { :method => :get }
    profile.search '/profiles', :action => :index, :conditions => { :method => :get }
    profile.profile '/profiles/:id', :action => :show, :conditions => { :method => :get }

    profile.connect '/my_profile', :action => :create, :conditions => { :method => :post }
    profile.connect '/my_profile', :action => :update, :conditions => { :method => :put }
  end

  map.resources :profiles, :only => :none do |profile|
    profile.resources :messages, :only => [:new, :create]
  end

  map.resources :passwords
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'

  map.search '/search', :controller => 'search'

  map.root :controller => "home"


  # ROUTES TO CLEAN UP / REMOVE ######################
  map.test_token '/test_token', :controller => 'test_token', :action => 'test_token'

  map.with_options(:controller => 'home') do |m|
    m.about            '/about',               :action => 'about'
    m.contact          '/contact',             :action => 'contact'
    m.tour          '/tour',                   :action => 'tour'
    m.home             '/',                    :action => 'index'
    m.tos              '/tos',                 :action => 'tos'
    m.event              '/event',             :action => 'event'
    m.event2              '/event2',           :action => 'event2'
    m.services_intro      '/services_intro',   :action => 'services_intro'
    m.file_too_large   '/file_too_large',      :action => 'file_too_large'
  end

  map.dashboard      '/dashboard',      :controller => 'dashboard',  :action => 'index'
  map.privacy        '/privacy',        :controller => 'home',       :action => 'privacy'
  map.terms          '/terms',          :controller => 'home',       :action => 'tos'
end
