class ApplicationController < ActionController::Base
  protect_from_forgery

  #TODO
  def require_login
    username = session[:username]
    if username
      @user = User.find(username) || User.new(username)
    else
      redirect_to '/auth/open_id?openid_url=https://www.google.com/accounts/o8/id'
    end
  end
end
