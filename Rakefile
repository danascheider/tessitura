require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'sinatra/asset_pipeline/task'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

# Open class so as not to start the server
# by requiring ./canto.rb (which contains the 
# Canto.run! statement) 
class Canto < Sinatra::Application
end

Cucumber::Rake::Task.new
RSpec::Core::RakeTask.new
Sinatra::AssetPipeline::Task.define! Canto

task :default => [:cucumber, :spec]