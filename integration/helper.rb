$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'localwiki_client'

def test_env_vars_set?
  return true if ENV['localwiki_client_server'] && ENV['localwiki_client_user'] && ENV['localwiki_client_apikey']
  puts "\nTo run all tests in the integration folder you need to do two things:"
  puts "\tContact a test server admin to request the hostname, and a username / apikey for your test server."
  puts "\tSet these three environment variables (working example given):"
  puts "\t\texport localwiki_client_server=ec2-54-234-151-52.compute-1.amazonaws.com"
  puts "\t\texport localwiki_client_user=testuser"
  puts "\t\texport localwiki_client_apikey=1ff0ed07625365b8d5589f17088f43b5ae227793"
end