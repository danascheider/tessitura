require 'mysql2'
require 'sequel'
require 'colorize'

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

  desc 'Migrate all databases'
  task :migrate, :PATH do |t, args|
    path = args[:path] || MIGRATION_PATH
    Rake::Task['db:development:migrate'].invoke(path)
    Rake::Task['db:test:migrate'].invoke(path)
    Rake::Task['db:production:migrate'].invoke(path)
    Rake::Task['db:schema:dump'].invoke(SCHEMA_PATH)
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

    desc 'Migrate the development database'
    task :migrate, [:PATH] => ['db:development:create'] do |t, args|
      path = args[:path] || MIGRATION_PATH
      Sequel::Migrator.run(DEV, path)
      STDOUT.puts 'Development database migrated successfully.'.green
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

    desc 'Migrate the production database'
    task :migrate, [:PATH] => ['db:production:create'] do |t, args|
      path = args[:path] || MIGRATION_PATH
      Sequel::Migrator.run(PRODUCTION, path)
      STDOUT.puts 'Production database migrated successfully.'.green
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

    desc 'Migrate the test database'
    task :migrate, [:PATH] => ['db:test:create'] do |t, args|
      path = args[:path] || MIGRATION_PATH
      Sequel::Migrator.run(TEST, path)
      STDOUT.puts 'Test database migrated successfully.'.green
    end

    desc 'Re-create test database and update schema'
    task :prepare, :PATH do |t, args|
      path = args[:path] || SCHEMA_PATH
      client.query('DROP DATABASE test')
      Rake::Task['db:test:migrate'].invoke(SCHEMA_PATH)
      puts "Success!".green
    end
  end
end