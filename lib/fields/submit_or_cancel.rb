class SubmitOrCancel < InputBaseClass
  def build
    submit_tag = template.submit_tag(submit_tag_value, :id => builder.object_name.to_s + "_submit")
    cancel_link = template.cancel_link(cancel_link_value)
    both = content_tag(:div, submit_tag + " or " + cancel_link, :class => "submit_or_cancel")
    content_tag(:div, both, :class => "submit")
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
  
    def cancel_link_value
      if options[:cancel_label]
        return options[:cancel_label]
      end
      return "Cancel"
    end
end