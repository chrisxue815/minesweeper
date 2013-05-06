class Auth::OpenIdController < ApplicationController
  def callback
    info = request.env["omniauth.auth"].info
    session[:username] = info.name
    redirect_to index_index_path
  end
end
