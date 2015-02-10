require 'pg'

class ServerNotReachableError < StandardError; end
class DatabaseAlreadyExistsError < StandardError; end

class PostgresHelper
  def initialize(params)
    @host = params['host']
    @username = params['username']
    @password = params['password']
    @port = params['port']
  end

  def create_database(db_name, username)
    begin
      connection.exec("CREATE DATABASE #{db_name}")
      connection.exec("CREATE USER #{username} WITH PASSWORD '#{username}'")
      connection.exec("GRANT ALL PRIVILEGES ON DATABASE #{db_name} TO #{username}")
    rescue => e
      if e.message.match /already exists/
        raise DatabaseAlreadyExistsError
      elsif e.message.match /could not connect/
        raise ServerNotReachableError
      else
        raise StandardError
      end
    end
    "http://#{@host}:#{@port}/databases/#{db_name}/#{username}"
  end

  def connection
    PG.connect(host: @host, user: @username,
               port: @port, dbname: 'postgres')
  end
end
