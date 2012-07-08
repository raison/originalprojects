class ImagesController < ApplicationController
  before_filter :require_profile
  before_filter :load_project
  before_filter :check_membership
  before_filter :add_console
  before_filter :set_console_section
  before_filter :scrub_input, :only => :update

  def edit
    render
  end

  def update
    add_notice "Images updated." if @project.update_attributes(@attributes)
    redirect_to :action => "edit"
  end

  private

  def set_console_section
    @console_section = :projects
  end

  def scrub_input
    @attributes = params[:project] || {}
    @attributes.reject! {|key, val| key != "images_attributes" }
  end
end
