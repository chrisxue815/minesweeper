class IndexController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_login

	def index
	end
end
