$LOAD_PATH.unshift(File.expand_path('./lib', File.dirname(__FILE__)))
require 'localwiki/version'

Gem::Specification.new do |s|
  s.name        = 'localwiki_client'
  s.version     = Localwiki::VERSION
  s.authors     = ["Brandon Faloona", "Seth Vincent"]
  s.description = %{ A thin client that wraps the Localwiki API. }
  s.summary     = "localwiki_client-#{s.version}"
  s.email       = 'brandon@faloona.net'
  s.homepage    = "http://github.com/bfaloona/localwiki_client"
  s.license     = 'MIT'
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency('faraday')
  s.add_dependency('json_pure')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '>= 2.9.0')
  #s.add_development_dependency('rspec-mocks', '>= 2.9.0')
  s.add_development_dependency('vcr')
  s.add_development_dependency('webmock', '>= 1.8.0', '< 1.10')

  s.add_development_dependency('rb-fsevent')

  unless ENV['TRAVIS'] == 'true'
    s.add_development_dependency('yard')
    s.add_development_dependency('redcarpet')
    s.add_development_dependency('flog')
    s.add_development_dependency('guard')
    unless ENV['RUBY_VERSION'] &&  ENV['RUBY_VERSION'].match(/jruby|rbx/)
      s.add_development_dependency('guard-rspec')
    end
  end


  s.post_install_message =
  %{
    Thank you for installing localwiki_client #{s.version}
  }

  s.files             = `git ls-files`.split("\n")
  s.rdoc_options      = ["--charset=UTF-8"]
  s.require_path      = "lib"
end
