require 'sinatra'
require 'json'
require 'yaml'

class PostgresBroker < Sinatra::Base
  use Rack::Auth::Basic do |username, password|
    credentials = {username: 'admin', password: 'admin'}
    username == credentials.fetch(:username) and password == credentials.fetch(:password)
  end

  get '/' do
    "hello world"
  end

  get '/v2/catalog' do
    content_type :json
    YAML.load_file('config/settings.yml').fetch('catalog').to_json
  end
end
