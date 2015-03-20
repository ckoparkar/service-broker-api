$: << File.expand_path("../../lib", File.dirname(__FILE__))

require 'capybara'
require 'capybara/cucumber'
require_relative '../../postgres_broker'

Capybara.app = PostgresBroker
