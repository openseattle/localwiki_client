
def load_json filename
  File.open(File.expand_path("../data", __FILE__) + "/#{filename}", 'r').read
end

def test_env_vars_set?
  return true if ENV['localwiki_client_user'] && ENV['localwiki_client_apikey']
  puts "\nSet these two environment variables to test #create\n\texport localwiki_client_user=USERNAME\n\texport localwiki_client_apikey=APIKEY"
end