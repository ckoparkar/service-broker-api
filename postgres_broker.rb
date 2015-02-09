require 'sinatra'

class PostgresBroker < Sinatra::Base
  use Rack::Auth::Basic do |username, password|
    credentials = {username: 'admin', password: 'admin'}
    username == credentials.fetch(:username) and password == credentials.fetch(:npassword)
  end

  get '/' do
    "hello world"
  end
end
