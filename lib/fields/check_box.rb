class CheckBox < InputBaseClass
  def build
    text_box = content_tag(:label, check_box_value, :for => builder.object_name.to_s + "_" + input_name.to_s, :style => "cursor:pointer")
    value = input_tag + " " + text_box
    if options[:set_label_before] == true
      value = text_box + " " + input_tag
    end
    
    content = content_tag(:div, value, :class => "label")
    content_tag(:div, content, :class => "row")
  end
  
  private
    def check_box_value
      if options[:label]
        return options[:label]
      end
      return " "
    end
end