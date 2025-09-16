class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

 def render_success (success: true, message: 'Success', data: nil)
   { success: success, message: message, data: data }
 end

 def render_error (success: false, message: 'Error', errors: [])
   { success: success, message: message, errors: errors }
 end
 
end
