# To change this template, choose Tools | Templates
# and open the template in the editor.

module OriginalProjects
  class FormBuilder < ActionView::Helpers::FormBuilder
    def field_for(field, options = {})      
      label_text = options.delete(:label) || @object.class.human_attribute_name(field)
      note_text = options.delete(:note)
      field_type = options.delete(:as)
      field_type ||= find_field_type(field)
      input_classes = [options.delete(:class)].compact
      input_classes << field_type
      required = options.delete(:required) || is_required?(field)
      label_classes = []
      if required
        input_classes << "required" 
        label_classes << "required"
      end
      options[:class] = input_classes.join(" ")
      label_class = label_classes.join(" ")
      
      label_html = label(field, label_text, :class => label_class)

      output = label_html
      output += "<br />"
      
      output += @template.content_tag(:div, :class => 'input_frame') do
        div = ""
        div += @template.content_tag(:p, note_text, :class => 'small_note') if note_text
        div += send(field_type, field, options)
        
        if block_given?
          div += yield 
        end
        
        div
      end
      
      @template.concat(output) if block_given?
      output
    end
    
    def label(field, text = nil, options = {})
      text ||=  if @object.class.respond_to?(:human_attribute_name) 
                then @object.class.human_attribute_name(field) 
                else field.to_s.humanize
                end

      unless @object.nil?
        # Check if there are any errors for this field in the model
        errors = @object.errors.on(field.to_sym)
        if errors
          # Generate the label using the text as well as the error message wrapped in a span with error class
          text += " <span class=\"error\">#{errors.is_a?(Array) ? errors.first : errors}</span>"
        end
      end
      #Finally hand off to super to deal with the display of the label
      super(field, text, options)
    end
    
    private
    
    def find_field_type(field)
      column_type = @object.class.columns_hash[field.to_s].try(:type)
      case column_type
      when :string then :text_field
      when :text then :text_area
      else :text_field
      end
    end
    
    def is_required?(field)
      validations = @object.class.reflect_on_validations_for(field)
      if validations.respond_to?(:[])
        validations.any? { |validation| validation.macro == :validates_presence_of }
      end
    end
  end
end
