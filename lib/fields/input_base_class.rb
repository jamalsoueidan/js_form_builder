class InputBaseClass 
  
  attr_accessor :options, :template, :builder, :input_name, :input_tag, :method_name
  
  def build
    raise "an error" rescue "You must override build method in your subclass"
  end
  
  # ------------------------------------------------------------------------ #
  # PROTECTED PROTECTED PROTECTED #
  # ------------------------------------------------------------------------ #
  
  protected
    def content_tag(tag, content, style)
      template.content_tag(tag, content, style)
    end
  
    def is_required?
      required = false
      if show_requirements?
        if object_reference && object_reference.respond_to?(:reflect_on_validations_for)
          required = object_reference.reflect_on_validations_for(is_required_input_name).map(&:macro).include?(:validates_presence_of)
        end
      end
      
      # must not be nil, either false or true.
      required = options[:required] unless options[:required].nil?
      return required
    end

    def has_errors?
      if builder.object
        builder.object.errors.invalid?(is_required_input_name)
      end
    end
  
    def input_style
      style = 'row'
      if is_required?
        style += ' required'
      end

      if has_errors?
        style += ' error'
      end
      
      style += ' ' + method_name
    
      return style
    end
  
    def label_text
      if options_label
        return options_label
      elsif active_record_label
        return active_record_label
      else
        input_name
      end
    end
    
    def label_object
      content = builder.label(input_name, label_text)
      content = if_required_option_is_declared(content)
      content = if_after_label_option_is_declared(content)
      content_tag(:div, content, :class => "label")
    end
  
    def input_object
      content = content_tag(:div, input_tag, :class => input_name)
      content = if_notice_option_is_declared(content)
      content = if_show_error_after_field_is_declared(content)
      content_tag(:div, content, :class => "input") 
    end
    
    def object_reference
      Object.const_get(builder.object_name.to_s.titleize)
    end
    
    def show_requirements?
      builder.options[:show_requirements]
    end
  
  # ------------------------------------------------------------------------ #
  # PRIVATE PRIVATE PRIVATE #
  # ------------------------------------------------------------------------ #  
  
  private
    def active_record_label
      object_reference.human_attribute_name(input_name)
    end
    
    def options_label
      options[:label]
    end
    
    def if_notice_option_is_declared(content)
      if options[:notice]
        content += content_tag(:div, options[:notice], :class => "notice")
      end
      return content
    end
    
    def if_after_label_option_is_declared(content)
      if options[:after_label]
        content += content_tag(:span, options[:after_label], :class => "after_label")
      end
      return content
    end
    
    def if_required_option_is_declared(content)
      if is_required?
         content += ' <em>required</em>'
      end
      return content
    end
    
    def if_show_error_after_field_is_declared(content)
      if has_errors?
        content += content_tag(:span, label_text + " " + builder.object.errors.on(is_required_input_name), :class => "show_error_after_field")
      end
      return content
    end
    
    def is_required_input_name
      return :password if input_name.to_s == "password_confirmation"
      return input_name
    end
end