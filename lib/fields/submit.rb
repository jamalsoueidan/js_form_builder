class Submit < InputBaseClass
  def build
    if options.class.to_s == "String"
      value = options
      options = {:label => value}
    end
    submit_tag = template.submit_tag(submit_tag_value, :id => builder.object_name.to_s + "_submit")
    content_tag(:div, submit_tag, :class => "submit")
  end
  
  private
     def submit_tag_value
        value = "Save changes"
        if options[:label]
          value = options[:label]
        elsif options[:submit_label]
          value = options[:submit_label]
        end 
        return value
      end
end