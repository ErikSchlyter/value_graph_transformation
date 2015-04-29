require "bundler/gem_tasks"
Bundler.setup

desc "Execute RSpec with default formatter"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--format RSpec::Formatters::IllustratedDocumentationFormatter"
end

desc "Execute RSpec with HTML formatter"
# RSpec - HTML output
RSpec::Core::RakeTask.new(:html_spec) do |t|
  t.rspec_opts = "spec/dot_html_formatter.rb --format RSpec::Formatters::IllustratedHtmlFormatter --out ./doc/rspec-results.html"
end

desc "Generate API documentation."
require 'yard'
YARD::Rake::YardocTask.new(:doc)
task :doc => [:html_spec]


desc "List the undocumented code."
YARD::Rake::YardocTask.new(:list_undoc) do |t|
  t.stats_options = ['--list-undoc']
end

task :default => :spec
