# JsFormbuilder
class JsFormBuilder < ActionView::Helpers::FormBuilder
    
  #http://tomek.codequest.eu/2008/12/28/how-to-write-a-custom-form-builder-in-rails/
  %w[text_field text_area password_field check_box submit].each do |method_name| 
    define_method(method_name) do |field_name, *args|
      
       options = args.extract_options!
       options[:field_object] = super
       options[:field_name] = field_name
       options[:method_name] = method_name
       
       @field_options = options
       
       case method_name
        when "password_field"
          js_password_field
        when "check_box"
          js_check_box
        when "submit"
          js_submit
        else
         js_input_field
       end
     end
   end
  
  def terms_of_service(text)
    html = @template.content_tag(:div, "", :class => "label")
    @field_options = {:field_object => text}
    html += div_field
    @template.content_tag(:div, html, :class => "row")
  end
  
  def submit_or_cancel(options={})    
    submit_tag = @template.submit_tag(submit_tag_value, :id => "#{object_name}_submit")
    cancel_link = @template.cancel_link(cancel_link_value)
    both = @template.content_tag(:div, submit_tag + " or " + cancel_link, :class => "submit_or_cancel")
    @template.content_tag(:div, both, :class => "submit")
  end
  
  def submit
    if field_options.class.to_s == "String"
      value = options
      field_options = {:label => value}
    end
    submit_tag = @template.submit_tag(submit_tag_value, :id => "#{object_name}_submit")
    @template.content_tag(:div, submit_tag, :class => "submit")
  end
  
  private
    # field_object is <input type="text" name="test" />
    # field_name is user_field
    def field_options
      @field_options
    end
  
    def object_reference
      Object.const_get(object_name.to_s.titleize)
    end
  
    def content_tag(name, content, options = nil)
      @template.content_tag(name, content, options)
    end
    
    def js_check_box   
      options[:field_object] += @template.content_tag(:span, check_box_value, :class => "check_box_text")
      html = @template.content_tag(:div, "", :class => "label")
      html += div_field
      @template.content_tag(:div, html, :class => "row")
    end
  
    def js_input_field
      class_style = field_style(field_options[:field_name])
      html = div_label
      html += div_field
      @template.content_tag(:div, html, :class => "row" + class_style)
    end
  
    def js_password_field
      js_input_field
    end
    
    def div_label
      content = label(field_options[:field_name], build_label)
      if is_required?(field_options[:field_name])
        content += ' <em>required</em>'
      end
      @template.content_tag(:div, content, :class => "label")
    end
    
    # 1. label option
    # 2. translated from locale
    # 3. field name by hash value
    def build_label
      field_label = field_options[:label]
      translated = object_reference.human_attribute_name(field_options[:field_name])
      if field_label
        return field_options[:label]
      elsif translated
        return translated
      else
        field_options[:field_name]
      end
    end
    
    def div_field
      content = @template.content_tag(:div, field_options[:field_object], :class => field_options[:method_name])
      if options[:notice]
        content += @template.content_tag(:div, field_options[:notice], :class => "notice")
      end
      
      @template.content_tag(:div, content, :class => "input")
    end
    
    def submit_tag_value
      value = "Save changes"
      if field_options[:label]
        value = field_options[:label]
      elsif field_options[:submit_label]
        value = field_options[:submit_label]
      end 
      return value
    end
    
    def cancel_link_value
      if field_options[:cancel_label]
        return field_options[:cancel_label]
      end
      return "Cancel"
    end
    
    def check_box_value
      if field_options[:label]
        return field_options[:label]
      end
      return " "
    end
    
    def is_required?(field_name)
      return false unless options[:show_requirements]
      if object_reference && object_reference.respond_to?(:reflect_on_validations_for)
       object_reference.reflect_on_validations_for(field_name).map(&:macro).include?(:validates_presence_of)
     end
    end

    def has_errors?(field_name)
      if object
        object.errors.invalid? field_name
      end
    end
    
    def field_errors(field_name)
      field_errors = ''
      if has_errors?(field_name)
        object.errors[field_name].each do |msg|
          field_errors += @template.content_tag(:dd, msg, :class => 'error')
      end
      end
      field_errors
    end

    def field_style(field_name)
      field_style = ''
      if is_required?(field_name) 
        field_style += ' required'
      end

      if has_errors?(field_name)
        field_style += ' error'
      end
      
      return field_style
    end    

    def objectify_options(options)
      super.except(:notice, :label)
    end
end



 # f.text_field :nas, :label => "someting", :around_label => {:tag => :div, :html => {:id => "lol"}}, :show_error => :on_field, :required => true, 