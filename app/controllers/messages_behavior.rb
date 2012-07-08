module MessagesBehavior
  def self.included(base)
    base.module_eval do
      before_filter :setup_messages
    end
  end

  private
  
  def add_form_error
    add_error("There were some issues with the information on the form. Please look at the form to see what to fix and try again.", :now => true)
  end

  def add_notice(message, options = {})
    add_message(:notice, message, options)
  end

  def add_error(message, options = {})
    add_message(:error, message, options)
  end

  def add_message(msg_type, message, options = {})
    if options.delete(:now)
      @messages[msg_type] << message
    else
      flash[:messages][msg_type] << message
    end
  end

  def setup_messages
    @messages = flash[:messages]
    @messages ||= {}
    @messages[:notice] ||= []
    @messages[:error] ||= []

    flash[:messages] = { :notice => [], :error => [] }
  end
end
