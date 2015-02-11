require 'sinatra/base'
require 'json'
require 'yaml'
require_relative 'postgres_helper'

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

  put '/v2/service_instances/:id' do |id|
    content_type :json
    username = "u#{id}"
    db_name = "d#{id}"

    begin
      db_url = postgres_service.create_database(db_name, username)
      status 201
      {'dashboard_url' => db_url}.to_json
    rescue DatabaseAlreadyExistsError
      status 409
      {'description' => "The database #{db_name} already exists."}.to_json
    rescue ServerNotReachableError
      status 500
      {'description' => 'PostgreSQL server is not reachable'}.to_json
    rescue => e
      {'description' => e.message}.to_json
    end
  end

  private

  def self.app_settings
    @app_settings ||= YAML.load_file('config/settings.yml')
  end

  def postgres_service
    postgres_settings = self.class.app_settings.fetch('postgresql')
    PostgresHelper.new(postgres_settings)
  end
end
