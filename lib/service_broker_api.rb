require 'sinatra/base'
require 'json'
require 'yaml'
require_relative 'postgresql_helper'

class ServiceBrokerApi < Sinatra::Base
  use Rack::Auth::Basic do |username, password|
    credentials = self.app_settings.fetch('basic_auth')
    username == credentials.fetch('username') and password == credentials.fetch('password')
  end

  get '/v2/catalog' do
    content_type :json
    self.class.app_settings.fetch('catalog').to_json
  end

  #PROVISION
  put '/v2/service_instances/:id' do |id|
    content_type :json

    db_name = "d#{id}"
    begin
      db_url = postgres_service.create_database(db_name)
      status 201
      {'dashboard_url' => db_url}.to_json
    rescue DatabaseAlreadyExistsError
      status 409
      {'description' => "The database #{db_name} already exists."}.to_json
    rescue ServerNotReachableError
      status 500
      {'description' => 'PostgreSQL server is not reachable'}.to_json
    rescue => e
      status 501
      {'description' => e.message}.to_json
    end
  end

  #BIND
  put '/v2/service_instances/:instance_id/service_bindings/:binding_id' do |instance_id, binding_id|
    content_type :json

    db_name = "d#{instance_id}"
    username = "u#{binding_id}"

    begin
      credentials = postgres_service.create_user(username, db_name)
      status 201
      {'credentials' => credentials}.to_json
    rescue UserAlreadyExistsError
      status 409
      {'description' => "The user #{username} already exists."}.to_json
    rescue DatabaseDoesNotExistError
      status 410
      {'description' => "The database #{db_name} does not exist."}.to_json
    rescue ServerNotReachableError
      status 500
      {'description' => 'PostgreSQL server is not reachable'}.to_json
    rescue => e
      status 501
      {'description' => e.message}.to_json
    end
  end

  #UNBIND
  delete '/v2/service_instances/:instance_id/service_bindings/:binding_id' do |instance_id, binding_id|
    content_type :json

    username = "u#{binding_id}"

    begin
      postgres_service.delete_user(username)
      status 200
      {}.to_json
    rescue UserDoesNotExistError
      status 410
      {'description' => "The user #{username} does not exist."}.to_json
    rescue ServerNotReachableError
      status 500
      {'description' => 'PostgreSQL server is not reachable'}.to_json
    rescue => e
      status 501
      {'description' => e.message}.to_json
    end
  end

  #DE-PROVISION
  delete '/v2/service_instances/:instance_id' do |instance_id|
    content_type :json

    db_name = "d#{instance_id}"

    begin
      postgres_service.delete_database(db_name)
      status 200
      {}.to_json
    rescue DatabaseDoesNotExistError
      status 410
      {'description' => "The database #{db_name} does not exist."}.to_json
    rescue ServerNotReachableError
      status 500
      {'description' => 'PostgreSQL server is not reachable'}.to_json
    rescue => e
      status 501
      {'description' => e.message}.to_json
    end
  end

  private

  def self.app_settings
    @app_settings ||= YAML.load_file('config/settings.yml')
  end

  def postgres_service
    postgres_settings = {
      'host' => ENV['POSTGRESQL_HOST'] || 'localhost',
      'username' => ENV['POSTGRESQL_USERNAME'] || 'admin',
      'password' => ENV['POSTGRESQL_PASSWORD'] || 'admin',
      'port' => ENV['POSTGRESQL_PORT'].to_i || 5432,
    }
    PostgresqlHelper.new(postgres_settings)
  end
end
