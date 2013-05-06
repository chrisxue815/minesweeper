require 'omniauth-openid'
require 'openid/store/filesystem'

Rails.application.config.middleware.use Rack::Session::Cookie

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openid, :store => OpenID::Store::Filesystem.new('db/openid')
end
