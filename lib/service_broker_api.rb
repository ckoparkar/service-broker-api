require 'sinatra/base'
require 'json'
require 'yaml'

class ServerNotReachableError < StandardError; end
class ServiceInstanceAlreadyExistsError < StandardError; end
class ServiceInstanceDoesNotExistError < StandardError; end
class BindingAlreadyExistsError < StandardError; end
class BindingDoesNotExistError < StandardError; end

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

    instance_name = "d#{id}"
    begin
      dashboard_url = create_instance(instance_name)
      status 201
      {'dashboard_url' => dashboard_url}.to_json
    rescue ServiceInstanceAlreadyExistsError
      status 409
      {'description' => "The database #{instance_name} already exists."}.to_json
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

    instance_name = "d#{instance_id}"
    binding_name = "u#{binding_id}"

    begin
      credentials = bind_instance(binding_name, instance_name)
      status 201
      {'credentials' => credentials}.to_json
    rescue BindingAlreadyExistsError
      status 409
      {'description' => "The user #{binding_name} already exists."}.to_json
    rescue ServiceInstanceDoesNotExistError
      status 410
      {'description' => "The database #{instance_name} does not exist."}.to_json
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

    binding_name = "u#{binding_id}"

    begin
      delete_binding(binding_name)
      status 200
      {}.to_json
    rescue BindingDoesNotExistError
      status 410
      {'description' => "The user #{binding_name} does not exist."}.to_json
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

    instance_name = "d#{instance_id}"

    begin
      delete_instance(instance_name)
      status 200
      {}.to_json
    rescue ServiceInstanceDoesNotExistError
      status 410
      {'description' => "The database #{instance_name} does not exist."}.to_json
    rescue ServerNotReachableError
      status 500
      {'description' => 'PostgreSQL server is not reachable'}.to_json
    rescue => e
      status 501
      {'description' => e.message}.to_json
    end
  end
end
