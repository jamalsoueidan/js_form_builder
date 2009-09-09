module JsActionView
  def js_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    options = filter_align(options)
    options = default_show_requirements(options)
    options = choose_style(options)
    
    concat('<div class="' + form_style(options) + '">')
      form_for(record_or_name_or_array, *(args << options.merge(:builder => JsFormBuilder)), &proc);
    concat('</div>')
   end
   
   def cancel_link(value="Cancel", options={})
     link_to(value, "/", options)
   end
   
   private
    def filter_align(options)
      if options[:html].nil?
        options[:html] = {}
        if options[:html][:class].nil?
          options[:html][:class] = ""
        end
      end

      if options[:align]
        options[:html][:class] += options[:align].to_s
      else
        options[:html][:class] += "vertical"
      end
      return options
    end
    
    def default_show_requirements(options)
      if options[:show_requirements].nil?
        options[:show_requirements] = true
      end
      return options
    end
    
    def choose_style(options)
      if options[:style].nil?
        options[:style] = "default"
      end
      return options
    end
    
    def form_style(options)
      options[:align].to_s + ' ' + options[:style]
    end
end