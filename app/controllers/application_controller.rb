class ApplicationController < ActionController::Base
  protect_from_forgery

  #TODO
  def require_login
    @user = current_user
  end
end
