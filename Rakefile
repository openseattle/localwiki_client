require 'rake'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'yard'

desc 'Default: run unit test specs'
task :default => :spec

desc 'Run all tests'
task :all => [:spec, :integration, :flog_detail]

desc "Run unit test specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/*_spec.rb"
  t.rspec_opts = ['-f d']
end

desc "Run unit test specs"
task :test => [:spec]

desc "Run integration tests"
RSpec::Core::RakeTask.new(:integration) do |t|
  t.pattern = "integration/*_spec.rb"
  t.rspec_opts = ['-f d']
end

desc "Flog the code! (*nix only)"
task :flog do
  system('find lib -name \*.rb | xargs flog')
end

desc "Detailed Flog report! (*nix only)"
task :flog_detail do
  system('find lib -name \*.rb | xargs flog -d')
end

desc "Generate YARD documentation for files in ['lib/**/*.rb']"
YARD::Rake::YardocTask.new(:yard)

desc "Delete VCR fixtures and logs"
task :vcr_purge do
  files = Dir[File.expand_path("../spec/fixtures/cassettes/*", __FILE__)].map do |file|
    file if File.file?(file)
  end
  files.each { |file| File.delete(file) }
end

desc "Sanitize VCR fixtures (remove Apikey values)"
task :vcr_sanitize do
  system(%{ruby -pi.bak -e "gsub(/- ApiKey .+:.+/, '- ApiKey testuser:key')" spec/fixtures/cassettes/*.yml})
end
