$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'localwiki_client'

#VCR.configure do |c|
#  c.ignore_request do |request|
#      true
#    end
#end

def test_env_vars_set?
  return true if ENV['localwiki_client_user'] && ENV['localwiki_client_apikey']
  puts "\nSet these two environment variables to test #create\n\texport localwiki_client_user=USERNAME\n\texport localwiki_client_apikey=APIKEY"
end