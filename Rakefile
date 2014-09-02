require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require './canto'

Dir.glob('tasks/*.rake').each {|file| load file }

Cucumber::Rake::Task.new
RSpec::Core::RakeTask.new

task :default => [:all]

desc "Run all tests."
task :all => [
  :cucumber,
  :spec,
]
