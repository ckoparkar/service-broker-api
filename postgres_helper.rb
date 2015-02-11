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

  def create_database(db_name)
    run_safely do
      connection.exec("CREATE DATABASE #{db_name}")
    end
    "http://#{@host}:#{@port}/databases/#{db_name}"
  end

  private

  def run_safely
    begin
      yield if block_given?
    rescue => e
      if e.message.match /already exists/
        raise DatabaseAlreadyExistsError
      elsif e.message.match /could not connect/
        raise ServerNotReachableError
      else
        raise StandardError
      end
    end
  end

  def connection
    PG.connect(host: @host, user: @username,
               port: @port, dbname: 'postgres')
  end
end
