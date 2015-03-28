require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$: << File.expand_path("../../lib", File.dirname(__FILE__))

require_relative '../../lib/service_broker_api'
require_relative '../../lib/postgresql_broker'
require 'rack/test'
require 'cucumber/rspec/doubles'

module AppHelper
  def app
	PostgresqlBroker
  end
end

World(Rack::Test::Methods, AppHelper)
