class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller? 

  private
    #ユーザー登録時に名前を登録できるようにする
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up,keys:[:name])
    end
end
