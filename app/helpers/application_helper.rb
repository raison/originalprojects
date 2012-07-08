# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def display_date(datetime)
    if datetime.today?
      datetime.strftime("Today @ %l:%M %p %Z")
    else
      datetime.strftime("%m-%d-%Y @ %l:%M %p %Z")
    end
  end

  def body_class
    @body_class ||= request.path[1..-1].gsub(/\//, '_')
  end

  def not_implemented(tag = :div)
    concat(content_tag(tag, :class => 'not_implemented') { yield })
  end

  alias_method :TODO, :not_implemented
  
  def show_console?
    @console ||= false
  end
  
  def show_sidebar?
    @show_sidebar = true unless defined?(@show_sidebar)    
    @show_sidebar
  end
  
  def s(string, config = Sanitize::Config::BASIC)
    Sanitize.clean(string, config)
  end
  
  # Form helpers

  def setup_with(obj, elements)
    returning(obj) do |o|
      o.send(elements).build
    end
  end

  def generate_form_template(form, name, options = {})
    name = name.to_s
    class_name = options[:class_name] || name.classify
    klass = class_name.constantize
    partial = [options[:partial_path], "#{name}_form"].compact.join("/")

    form.fields_for(name.pluralize, klass.new, :child_index => 'NEW_RECORD') do |obj_form|
      render(:partial => partial, :locals => { :form => obj_form })
    end.gsub(/\s+/, ' ').inspect
  end

  def envelope
    if @envelope_class.blank?
      @envelope_class = 'with_sidebar'
    else
      @envelope_class = (Array(@envelope_class).map(&:to_s)).join(' ')
    end
    @envelope_class ||= []
    concat(content_tag(:div, :id => 'envelope', :class => @envelope_class) do
      yield
    end)
  end

  def pluralize_by_count(word, count)
    count == 1 ? word : word.pluralize
  end

  def render_messages
    output = []

    @messages.each do |msg_type, messages|
      messages.each do |message|
        output << render_message(msg_type, message)
      end
    end

    content_tag(:div, output.join("\n"), :id => 'messages') unless output.empty?
  end

  def render_message(msg_type, message)
    content_tag(:div, message, :class => "message #{msg_type}")
  end

  def render_sidebar    
    @sidebar ||= "layouts/long_sidebar"
    @sidebar = { :partial => @sidebar } if @sidebar.is_a?(String)
    render @sidebar
  end
end
