require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rubygems/package_task'
require 'rspec/core/rake_task'
require 'spree/testing_support/extension_rake'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new

task default: :spec

spec = eval(File.read('spree_mobility.gemspec'))

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
end

desc 'Generates a dummy app for testing'
task :test_app do
  ENV['LIB_NAME'] = 'spree_mobility'
  Rake::Task['extension:test_app'].invoke
end
