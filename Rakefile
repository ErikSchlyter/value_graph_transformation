require "bundler/gem_tasks"
Bundler.setup

require 'rake/clean'
require 'yard'
require 'rspec/illustrate/yard'
require "rspec/core/rake_task"

desc "Execute tests"
RSpec::Core::RakeTask.new(:test)

desc "Execute RSpec and create a test report at ./doc/api.rspec."
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--format RSpec::Formatters::YARD --out ./doc/api.rspec"
end

desc "Create documentation."
YARD::Rake::YardocTask.new(:doc) do |t|
  t.files   = ['lib/**/*.rb', 'doc/api.rspec', '-', 'doc/api.rspec']
end
task :doc => [:spec]
CLEAN.include("doc")
CLEAN.include(".yardoc")

desc "List the undocumented code."
YARD::Rake::YardocTask.new(:list_undoc) do |t|
  t.stats_options = ['--list-undoc']
end

task :default => :doc
