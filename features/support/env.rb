$: << File.expand_path("../../lib", File.dirname(__FILE__))

require_relative '../../lib/postgresql_broker'
require 'rack/test'
require 'cucumber/rspec/doubles'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

module AppHelper
  def app
	PostgresqlBroker
  end
end

World(Rack::Test::Methods, AppHelper)
