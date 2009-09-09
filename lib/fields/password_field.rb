class PasswordField < InputBaseClass
  def build
    content = label_object
    content += input_object
    content_tag(:div, content, :class => "input")
  end
end