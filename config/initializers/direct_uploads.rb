require 'active_storage/direct_uploads_controller'
 
class ActiveStorage::DirectUploadsController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
end