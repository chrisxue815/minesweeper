class ApplicationController < ActionController::Base
  protect_from_forgery

  #TODO
  def require_login
    username = request.session_options[:id]
    @user = User.find(username) || User.new(username)
  end
end
