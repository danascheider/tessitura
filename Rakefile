require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'sinatra/asset_pipeline/task'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require './canto'

Cucumber::Rake::Task.new
RSpec::Core::RakeTask.new
Sinatra::AssetPipeline::Task.define! Canto

task :default => [:cucumber, :spec]