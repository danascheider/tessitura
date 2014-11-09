require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'colorize'
require './canto'

Dir.glob('tasks/*.rake').each {|file| load file }

Cucumber::Rake::Task.new
RSpec::Core::RakeTask.new

task 'suite:run' do 
  Rake::Task[:spec].invoke
  Rake::Task['db:test:prepare'].invoke
  Rake::Task[:cucumber].invoke
end

task :default => [:all]

desc "Run all tests."
task :all => [
  'suite:run'
]