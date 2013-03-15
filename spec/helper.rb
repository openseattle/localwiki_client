$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'localwiki_client'
require 'vcr'
require 'webmock/rspec'


VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  # c.debug_logger = File.open('spec/fixtures/cassettes/debug_vcr.log', 'w')
end

def test_env_vars_set?
  return true if ENV['localwiki_client_user'] && ENV['localwiki_client_apikey']
  puts "\nSet these two environment variables to test #create\n\texport localwiki_client_user=USERNAME\n\texport localwiki_client_apikey=APIKEY"
end