$: << File.expand_path("../../lib", File.dirname(__FILE__))

require_relative '../../postgres_broker'
require 'rack/test'
require 'cucumber/rspec/doubles'

module AppHelper
  def app
	PostgresBroker
  end
end

World(Rack::Test::Methods, AppHelper)
