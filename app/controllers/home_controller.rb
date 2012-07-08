class HomeController < ApplicationController
  before_filter :full_width, :except => :about

  def about
    @clip = params[ :clip ]
  end
  
  def file_too_large; end

  def contact
    if request.post?
      if params[:contact][:email].present?
        Mailer.deliver_feedback(params[:contact])
        add_notice "Thanks for your feedback!"
        redirect_to contact_url
      else
        add_error "Please enter a valid email address."
      end
    end
  end
  
    def services_intro
    if request.post?
      if params[:contact][:email].present?
        Mailer.deliver_feedback(params[:contact])
        add_notice "Thanks for your interest in Original Services!"
        redirect_to services_intro_url
      else
        add_error "Please enter a valid email address."
      end
    end
  end

  def index
    @envelope_class = %w(full_width home)
  end

  def privacy
  end

  def report_problem
  end

  def tos
  end
  
  def about
    full_width unless logged_in?
  end
end
