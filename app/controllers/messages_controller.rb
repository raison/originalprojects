class MessagesController < ApplicationController
  before_filter :require_profile
  before_filter :load_resource
  before_filter :set_title
  before_filter :set_receivers, :only => :create

  def new
    @message = Message.new(:subject => params[:subject])

    respond_to do |format|
      format.html
      format.js {
        render :partial => "form", :locals => {
          :return_to => params[:return_to],
          :title    => @title,
          :resource => @resource,
          :message  => @message
        }
      }
    end
  end

  def create
    @message      = Message.new(params[:message])
    @message.from = current_profile
    @message.to   = @receivers || @resource
    
    @return_to = params[:return_to]

    if @message.valid? and verify_recaptcha(:model => @message)
      @message.deliver
      add_notice "Your message was delivered."
      redirect_to(@return_to || @resource)
    else
      add_error @message.errors.full_messages.join("; "), :now => true
      render :action => "new"
    end
  end

  private
  
  def load_resource 
	if params[:profile_id]
      	@resource = Profile.find(params[:profile_id])
     
	elsif params['return_to'].include?('/services/')
		@resource = load_service
		else
		@resource = load_project
		end

   end

  def set_title
    @title = "the Originators of #{@resource.title}" if @resource.is_a?(Project)
    @title = "the Originators of #{@resource.title}" if @resource.is_a?(Service)
  end

  def set_receivers
    @receivers = @resource.originators if @resource.is_a?(Project)
    @receivers = @resource.originators if @resource.is_a?(Service)
  end
end
