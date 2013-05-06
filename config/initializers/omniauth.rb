require 'omniauth-openid'
require 'openid/store/filesystem'

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :open_id, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end
