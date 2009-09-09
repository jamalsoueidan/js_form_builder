class InputBaseClass 
  
  attr_accessor :options, :template, :builder, :input_name, :input_tag
  
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
      return false if options[:show_requirements] == false
      if object_reference && object_reference.respond_to?(:reflect_on_validations_for)
        object_reference.reflect_on_validations_for(input_name).map(&:macro).include?(:validates_presence_of)
      end
    end

    def has_errors?
      if builder.object
        builder.object.errors.invalid?(input_name)
      end
    end
  
    def input_style
      style = 'row '
      if is_required?
        style += ' required'
      end

      if has_errors?
        style += ' error'
      end
    
      return style
    end
  
    def label_text
      if options_label
        return options_label
      else
        input_name
      end
    end
    
    def label_object
      content = builder.label(input_name, label_text)
      content = put_required_if_required_is_true(content)
      content_tag(:div, content, :class => "label")
    end
  
    def input_object
      content = content_tag(:div, input_tag, :class => input_name)
      return put_notice_if_text_exists(content)
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
    
    def put_notice_if_text_exists(content)
      if options[:notice]
        content += content_tag(:div, options[:notice], :class => "notice")
      end
      return content
    end
    
    def put_required_if_required_is_true(content)
      if is_required?
         content += ' <em>required</em>'
      end
      return content
    end
    
    def object_reference
      Object.const_get(builder.object_name.to_s.titleize)
    end
end