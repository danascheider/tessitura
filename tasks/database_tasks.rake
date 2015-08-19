require 'mysql2'
require 'sequel'
require 'colorize'

namespace :db do 
  desc 'Create the production and test databases'
  task :create do 
    Rake::Task['db:production:create'].invoke
    Rake::Task['db:test:create'].invoke
  end

  desc 'Migrate the production and test databases'
  task :migrate, [:PATH] do |t, args|
    path = args[:path] || MIGRATION_PATH
    Rake::Task['db:production:migrate'].invoke(path)
    Rake::Task['db:test:migrate'].invoke(path)
  end

  desc 'Drop production and test databases'
  task 'drop:all' do 
    Rake::Task['db:production:drop'].invoke
    Rake::Task['db:test:drop'].invoke
  end

  namespace :production do 
    client = Mysql2::Client.new(YAML_DATA['production'])

    desc 'Create the production database'
    task :create do 
      begin
        client.query('CREATE DATABASE production;')
        STDOUT.puts 'Database \'production\' created.'.green
      rescue Mysql2::Error
        STDERR.puts 'Database \'production\' exists...'.blue
      end
    end

    desc 'Drop the production database'
    task :drop do 
      STDOUT.puts "Dropping the production database can cause irretrievable data loss. Proceed? (Anything but 'yes' will cancel request)"

      if STDIN.gets.chomp === 'yes'
        begin
          client.query('DROP DATABASE production;')
          STDOUT.puts 'The target has been neutralized.'.green
        rescue Mysql2::Error
          STDERR.puts 'Database \'production\' was not found.'.yellow
        end
      else
        STDOUT.puts 'Request canceled.'.blue
      end
    end

    desc 'Migrate the production database'
    task :migrate, [:PATH] => ['db:production:create'] do |t, args|
      db = Sequel.connect(DatabaseTaskHelper.get_string(YAML_DATA['production'], 'production'))
      path = args[:path] || MIGRATION_PATH
      Sequel::Migrator.run(db, path, allow_missing_migration_files: true)
      STDOUT.puts 'Database \'production\' migrated successfully.'.green
    end
  end

  namespace :test do 
    client = Mysql2::Client.new(YAML_DATA['test'])

    desc 'Create the test database'
    task :create do 
      begin
        client.query('CREATE DATABASE test;')
        STDOUT.puts 'Database \'test\' created.'.green
      rescue Mysql2::Error
        STDERR.puts 'Database \'test\' exists...'.blue
      end
    end

    desc 'Drop the test database'
    task :drop do 
      begin
        client.query('DROP DATABASE test;')
        STDOUT.puts 'The target has been neutralized.'.green
      rescue Mysql2::Error
        STDERR.puts 'Database \'test\' was not found.'.yellow
      end
    end

    desc 'Migrate the test database'
    task :migrate, [:PATH] => ['db:test:create'] do |t, args|
      db = Sequel.connect(DatabaseTaskHelper.get_string(YAML_DATA['test'], 'test'))
      path = args[:path] || MIGRATION_PATH
      Sequel::Migrator.run(db, path, allow_missing_migration_files: true)
      STDOUT.puts 'Database \'test\' migrated successfully.'.green
    end

    desc 'Reset the test database' 
    task :prepare, :PATH do |t, args|
      path = args[:path] || SCHEMA_PATH
      client.query('use test')
      client.query('SET FOREIGN_KEY_CHECKS = 0')
      client.query('TRUNCATE TABLE tasks')
      client.query('TRUNCATE TABLE fachs')
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
end
