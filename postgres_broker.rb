require 'sinatra/base'
require 'json'
require 'yaml'

class PostgresBroker < Sinatra::Base
  use Rack::Auth::Basic do |username, password|
    credentials = self.app_settings.fetch('basic_auth')
    username == credentials.fetch('username') and password == credentials.fetch('password')
  end
  get '/' do
    "hello world"
  end

  get '/v2/catalog' do
    content_type :json
    self.class.app_settings.fetch('catalog').to_json
  end

  private

  def self.app_settings
    YAML.load_file('config/settings.yml')
  end
end
