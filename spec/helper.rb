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

unless ENV['localwiki_client_server'] && ENV['localwiki_client_user'] && ENV['localwiki_client_apikey']
  puts "\nTo add or modify tests in the spec folder you need to do two things:"
  puts "\tContact a test server admin to request the hostname, and a username / apikey for your test server."
  puts "\tSet these three environment variables (working example given):"
  puts "\t\texport localwiki_client_server=ec2-54-234-151-52.compute-1.amazonaws.com"
  puts "\t\texport localwiki_client_user=testuser"
  puts "\t\texport localwiki_client_apikey=1ff0ed07625365b8d5589f17088f43b5ae227793"
end
