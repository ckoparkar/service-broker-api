require 'sinatra'

class PostgresBroker < Sinatra::Base
  get '/' do
    "hello world"
  end
end
