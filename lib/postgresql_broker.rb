require_relative 'postgresql_helper'

class PostgresqlBroker < ServiceBrokerApi
  def create_instance(instance_name)
    service.create_database(instance_name)
  end

  def bind_instance(binding_name, instance_name)
    service.create_user(binding_name, instance_name)
  end

  def delete_binding(binding_name)
    service.delete_user(binding_name)
  end

  def delete_instance(instance_name)
    service.delete_database(instance_name)
  end

  def service
    postgres_settings = {
      'host' => ENV.fetch('POSTGRESQL_HOST', 'localhost'),
      'username' => ENV.fetch('POSTGRESQL_USERNAME', 'postgres'),
      'password' => ENV.fetch('POSTGRESQL_PASSWORD', 'postgres'),
      'port' => ENV.fetch('POSTGRESQL_PORT', 5432),
    }
    PostgresqlHelper.new(postgres_settings)
  end

  def ServiceBrokerApi.app_settings
    @app_settings ||= YAML.load_file('config/settings.yml')
  end
end
