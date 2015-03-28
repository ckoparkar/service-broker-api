require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$: << File.expand_path("../../lib", File.dirname(__FILE__))

require_relative '../../lib/service_broker_api'
require 'rack/test'
require 'cucumber/rspec/doubles'

module AppHelper
  def app
	ServiceBrokerApi
  end
end

World(Rack::Test::Methods, AppHelper)
