$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require_relative 'local_wiki/local_wiki'
require_relative 'local_wiki/version'