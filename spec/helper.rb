
def load_json filename
  File.open(File.expand_path("../data", __FILE__) + "/#{filename}", 'r').read
end