require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require './canto'

Cucumber::Rake::Task.new
RSpec::Core::RakeTask.new
Rake::Task['db:test:prepare'].invoke

task :default => [:all]

desc "Run all tests."
task :all => [
  :cucumber,
  :spec,
]
