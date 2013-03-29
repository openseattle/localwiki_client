$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'localwiki_client'

def test_env_vars_set?
  return true if ENV['localwiki_client_user'] && ENV['localwiki_client_apikey']
  puts "\nTo run all tests in the integration folder you need to do two things:"
  puts "\tContact sethvincent@gmail.com to request a username and apikey on the test server."
  puts "\tSet these two environment variables:\n\t\texport localwiki_client_user=USERNAME\n\t\texport localwiki_client_apikey=APIKEY"
end