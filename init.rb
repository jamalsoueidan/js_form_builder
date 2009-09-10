# Include hook code here
require 'js_form_builder'
require 'js_action_view'

require File.dirname(__FILE__) + "/lib/fields/required_files"

ActionView::Base.send(:include, JsActionView)

# To remove <div class="fieldWithErrors"> around errors.
ActionView::Base.field_error_proc = proc { |input, instance| input } 