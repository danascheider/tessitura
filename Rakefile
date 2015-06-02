require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'colorize'
require 'fileutils'
require File.expand_path '../config/database_task_helper', __FILE__
require File.expand_path '../lib/tessitura', __FILE__

MIGRATION_PATH = File.expand_path('../db/migrate', __FILE__)
SCHEMA_PATH    = File.expand_path('../db/schema_migrations', __FILE__)
YAML_DATA      = DatabaseTaskHelper.get_yaml(File.expand_path(ENV['DB_YAML_FILE'], FileUtils.pwd()) || File.expand_path('config/database.yml', __FILE__))

Dir['tasks/*.rake'].each {|file| load file }

Cucumber::Rake::Task.new
RSpec::Core::RakeTask.new

task 'suite:run' do 
  Rake::Task[:spec].invoke 
  Rake::Task['db:prepare'].invoke 
  Rake::Task[:cucumber].invoke
end

task :default => [:all]

desc "Run all tests."
task :all => [
  'suite:run'
]
