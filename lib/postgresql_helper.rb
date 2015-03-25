require 'pg'

class ServerNotReachableError < StandardError; end
class DatabaseAlreadyExistsError < StandardError; end
class DatabaseDoesNotExistError < StandardError; end
class UserAlreadyExistsError < StandardError; end
class UserDoesNotExistError < StandardError; end

class PostgresqlHelper
  def initialize(params)
    @host = params['host']
    @username = params['username']
    @password = params['password']
    @port = params['port']
  end

  def create_database(db_name)
    db_name = escape_dashes(db_name)
    run_safely do
      connection.exec("CREATE DATABASE #{db_name}")
      connection.exec("REVOKE ALL ON DATABASE #{db_name} FROM public")
    end
    "http://#{@host}:#{@port}/databases/#{db_name}"
  end

  def create_user(username, db_name)
    db_name = escape_dashes(db_name)
    username = escape_dashes(username)
    run_safely do
      connection.exec("CREATE USER #{username} WITH PASSWORD '#{username}'")
      connection.exec("GRANT ALL PRIVILEGES ON DATABASE #{db_name} TO #{username}")
    end
    {
      hostname: @host,
      port: @port,
      db_name: db_name,
      username: username,
      password: username,
      uri: "postgresql://#{username}:#{username}@#{@host}:#{@port}/#{db_name}",
      jdbcUrl: "jdbc:postgresql://#{username}:#{username}@#{@host}:#{@port}/#{db_name}"
    }
  end

  def delete_user(username)
    username = escape_dashes(username)
    run_safely do
      connection.exec("DROP OWNED BY #{username} CASCADE")
      connection.exec("DROP ROLE #{username}")
    end
  end

  def delete_database(db_name)
    db_name = escape_dashes(db_name)
    run_safely do
      connection.exec("DROP DATABASE #{db_name}")
    end
  end

  private

  def escape_dashes(x)
    x.gsub('-','_')
  end

  def run_safely
    begin
      yield if block_given?
    rescue => e
      if e.message.match /database \".*\" already exists/
        raise DatabaseAlreadyExistsError
      elsif e.message.match /database \".*\" does not exist/
        raise DatabaseDoesNotExistError
      elsif e.message.match /role \".*\" already exists/
        raise UserAlreadyExistsError
      elsif e.message.match /role \".*\" does not exist/
        raise UserDoesNotExistError
      elsif e.message.match /could not connect/
        raise ServerNotReachableError
      else
        raise StandardError
      end
    end
  end

  def connection
    @conn ||= PG.connect(host: @host, user: @username,
                        port: @port, dbname: 'postgres')
  end

  def escape_dashes(n)
    n.gsub('-','_')
  end
end
