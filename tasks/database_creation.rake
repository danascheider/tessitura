require 'mysql2'
require 'sequel'
require 'colorize'

require_relative 'database_task_helper'

YAML_DATA  = DatabaseTaskHelper.get_yaml(File.expand_path('config/database.yml'))
DEV        = Sequel.connect(DatabaseTaskHelper.get_string(YAML_DATA['development'], 'development'))
TEST       = Sequel.connect(DatabaseTaskHelper.get_string(YAML_DATA['test'], 'test'))
PRODUCTION = Sequel.connect(DatabaseTaskHelper.get_string(YAML_DATA['production'], 'production'))

namespace :db do 
  desc 'Create all databases'
  task :create do 
    Rake::Task['db:development:create'].invoke
    Rake::Task['db:test:create'].invoke
    Rake::Task['db:production:create'].invoke
  end

  desc 'Drop development and test databases'
  task :drop do 
    Rake::Task['db:development:drop'].invoke
    Rake::Task['db:test:drop'].invoke
  end

  desc 'Drop all databases'
  task 'drop:all' do 
    Rake::Task['db:development:drop'].invoke
    Rake::Task['db:test:drop'].invoke
    Rake::Task['db:production:drop'].invoke
  end

  namespace :development do 
    client = Mysql2::Client.new(YAML_DATA['development'])

    desc 'Create the development database'
    task :create do 
      begin
        client.query('CREATE DATABASE development;')
        STDOUT.puts 'Development database created.'.green
      rescue Mysql2::Error
        STDOUT.puts 'Development database exists...'.blue
      end
    end

    desc 'Drop the development database' 
    task :drop do 
      begin
        client.query('DROP DATABASE development;')
        STDOUT.puts 'Development database dropped successfully.'.green
      rescue Mysql2::Error
        STDOUT.puts 'Development database was not found.'.yellow
      end
    end
  end

  namespace :test do 
    client = Mysql2::Client.new(YAML_DATA['test'])
    
    desc 'Create the test database'
    task :create do 
      begin
        client.query('CREATE DATABASE test;')
        STDOUT.puts 'Test database created.'.green
      rescue Mysql2::Error
        puts 'Test database exists...'.blue
      end
    end

    desc 'Drop the test database'
    task :drop do 
      begin
        client.query('DROP DATABASE test;')
        STDOUT.puts 'Test database dropped successfully.'.green
      rescue Mysql2::Error
        STDOUT.puts 'Test database was not found.'.yellow
      end
    end
  end

  namespace :production do 
    client = Mysql2::Client.new(YAML_DATA['production'])

    desc 'Create the production database'
    task :create do
      begin
        client.query('CREATE DATABASE production')
        STDOUT.puts 'Production database created.'.green
      rescue
        STDOUT.puts 'Production database exists...'.blue
      end
    end

    desc 'Drop the production database'
    task :drop do 
      STDOUT.puts "Dropping the production database can cause irretrievable data loss. Proceed? (Anything but 'yes' will cancel request)"

      if STDIN.gets.chomp === 'yes'
        begin
          client.query('DROP DATABASE production;')
          STDOUT.puts 'Production database dropped successfully.'.green
        rescue Mysql2::Error
          STDOUT.puts 'Production database was not found.'.yellow
        end
      else
        STDOUT.puts 'Request canceled.'.yellow
      end
    end
  end
end