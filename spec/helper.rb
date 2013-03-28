begin
  require 'simplecov'
  SimpleCov.start if ENV["COVERAGE"]
rescue Exception => e
  puts 'Run "gem install simplecov" to enable code coverage reporting'
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'localwiki_client'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = File.expand_path("fixtures/cassettes", File.dirname(__FILE__))
  c.hook_into :webmock
  # c.debug_logger = File.open('spec/fixtures/cassettes/debug_vcr.log', 'w')
end

unless ENV['localwiki_client_user'] && ENV['localwiki_client_apikey']
  puts "\nTo add or modify tests in the spec folder you need to do two things:"
  puts "\tContact sethvincent@gmail.com to request a username and apikey on the test server."
  puts "\tSet these two environment variables:\n\t\texport localwiki_client_user=USERNAME\n\t\texport localwiki_client_apikey=APIKEY"
end
