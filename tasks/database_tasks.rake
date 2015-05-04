require 'mysql2'
require 'sequel'
require 'colorize'

namespace :db do 
  client = Mysql2::Client.new(YAML_DATA['defaults'])

  desc 'Create the default database'
  task :create do 
    begin
      client.query('CREATE DATABASE defaults;')
      STDOUT.puts 'Database \'defaults\' created.'.green
    rescue Mysql2::Error
      STDOUT.puts 'Database \'defaults\' exists...'.blue
    end
  end

  desc 'Drop the database'
  task :drop do 
    STDOUT.puts "Dropping the database can cause irretrievable data loss. Proceed? (Anything but 'yes' will cancel request)"

    if STDIN.gets.chomp === 'yes'
      begin
        client.query('DROP DATABASE defaults;')
        STDOUT.puts 'The target has been neutralized.'.green
      rescue Mysql2::Error
        STDOUT.puts 'Database \'defaults\' was not found.'.yellow
      end
    else
      STDOUT.puts 'Request canceled.'.blue
    end
  end

  desc 'Migrate the database'
  task :migrate, [:PATH] => ['db:development:create'] do |t, args|
    path = args[:path] || MIGRATION_PATH
    Sequel::Migrator.run(DB, path)
    STDOUT.puts 'Development database migrated successfully.'.green
  end

  desc 'Reset the test database' 
  task :prepare, :PATH do |t, args|
    path = args[:path] || SCHEMA_PATH
    client.query('SET FOREIGN_KEY_CHECKS = 0')
    client.query('TRUNCATE TABLE tasks')
    client.query('TRUNCATE TABLE task_lists')
    client.query('TRUNCATE TABLE users')
    client.query('TRUNCATE TABLE organizations')
    client.query('TRUNCATE TABLE programs')
    client.query('TRUNCATE TABLE seasons')
    client.query('TRUNCATE TABLE auditions')
    client.query('TRUNCATE TABLE listings')
    client.query('SET FOREIGN_KEY_CHECKS = 1')
    puts "Success!".green
  end
end