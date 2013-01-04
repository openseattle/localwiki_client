require 'rake'
require 'rspec/core'
require 'rspec/core/rake_task'

desc 'Default: run tests'
task :default => :test

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/*_spec.rb"
  t.rspec_opts = ['-f d']
end

desc "Run tests"
task :test do
  Rake::Task['spec'].invoke
end

desc "Run integration tests"
RSpec::Core::RakeTask.new(:integration) do |t|
  t.pattern = "spec/integration/*_spec.rb"
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