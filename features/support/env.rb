require "rspec/expectations"
require 'cucumber'
require 'cucumber/cli/options'
require 'json'
require 'time'
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require "selenium-webdriver"
require 'net/http'
require 'uri'
require 'cgi'

def url
    "http://#{host}"
end

def host
    host_address = ENV['host']
    host_address = 'www.google.com'
    return host_address
end

$host = host

Capybara.app_host = url
Capybara.default_driver = :selenium
Capybara.use_default_driver
Capybara.default_wait_time = 20
Capybara.default_selector = :css

unless (env_no = ENV['TEST_ENV_PORT'].to_i).zero?
	Capybara.server_port = env_no
end

puts "Capybara.server_port = #{Capybara.server_port}"

Capybara.register_driver :selenium do |app|
  http_client = Selenium::WebDriver::Remote::Http::Default.new
  http_client.timeout = 100
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :http_client => http_client)
end

class TestWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  TestWorld.new
end


def attempt_and_wait(&block)
  i = 0
  backoff = 0.1
  begin
     block.call
  rescue => e
    p e.message
      puts "#Failed. Retry in #{backoff.to_s} seconds."
      sleep(backoff)
      backoff = backoff + 0.1
      i = i + 1
      if i < 20
          retry
      else
      raise "Failed after multiple attempts"
      end
  end
end