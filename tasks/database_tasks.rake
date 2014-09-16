require 'mysql2'
require 'sequel'
require 'yaml'

Sequel.extension :migration

yaml_data = File.open(File.expand_path('../../config/database.yml', __FILE__), 'r+') {|file| YAML.load(file) }
[yaml_data['development'], yaml_data['test'], yaml_data['production']].each do |hash|
  hash.keys.each do |key|
    hash[(key.to_sym rescue key) || key] = hash.delete(key)
  end
end

DEV, TEST, PRODUCTION = yaml_data['development'], yaml_data['test'], yaml_data['production']

MIGRATION_PATH = File.expand_path('../../db/migrate', __FILE__)
SCHEMA_PATH = File.expand_path('../../db/schema_migrations', __FILE__)

module DatabaseTaskHelper
  def self.connection(hash, env)
    "#{hash[:adapter]}://#{hash[:username]}:#{hash[:password]}@#{hash[:host]}:#{hash[:port]}/#{env}"
  end
end

namespace :db do 
  desc 'Create all databases except those that currently exist'
  task :create do 
    Rake::Task['db:development:create'].invoke
    Rake::Task['db:production:create'].invoke
    Rake::Task['db:test:create'].invoke
    puts "Success!".green
  end

  desc 'Create new migration, required arg NAME, default PATH /db/migrate'
  task :create_migration, [:NAME, :PATH] do |t, args|
    path = args[:path] || MIGRATION_PATH
    Dir.mkdir(path) unless Dir.exists?(path)

    File.open((name="#{path}/#{Time.now.getutc.to_s.gsub(/\D/, '')}_#{args[:NAME]}.rb"), 'w+') do |file|
      file.write <<-EOF
Sequel.migration do 
  up do
  end

  down do 
  end
end
EOF
    end
    puts "Migration created at #{path}/#{name}".green
  end

  desc 'Migrate all databases'
  task :migrate, :PATH do |t, args|
    path = args[:path] || MIGRATION_PATH
    Rake::Task['db:development:migrate'].invoke(path)
    Rake::Task['db:test:migrate'].invoke(path)
    Rake::Task['db:production:migrate'].invoke(path)
    Rake::Task['db:schema:dump'].invoke(SCHEMA_PATH)
  end

  desc 'Drop test and development databases'
  task :drop do 
    Rake::Task['db:development:drop'].invoke 
    Rake::Task['db:test:drop'].invoke 
  end

  desc 'Drop all databases, including production'
  task 'drop:all' do 
    Rake::Task['db:development:drop'].invoke 
    Rake::Task['db:test:drop'].invoke
    Rake::Task['db:production:drop'].invoke
  end

  namespace :schema do
    desc 'Load schema into database'
    task :load, :PATH do |t, args|
      dev        = Sequel.connect(DatabaseTaskHelper.connection(DEV, 'development'))
      test       = Sequel.connect(DatabaseTaskHelper.connection(TEST, 'test'))
      production = Sequel.connect(DatabaseTaskHelper.connection(PRODUCTION, 'production'))

      [dev, test, production].each {|db| db.extension :schema_caching }

      path = args[:path] || SCHEMA_PATH

      Rake::Task["db:development:migrate"].invoke(path)
      Rake::Task["db:test:migrate"].invoke(path)
      Rake::Task["db:production:migrate"].invoke(path)
      puts 'Success!'.green
    end

    desc 'Dump schema to a schema file'
    task :dump, [:PATH] => ['db:development:create'] do |t, args|
      timestamp = Time.now.getutc.to_s.gsub(/\D/, '')
      path      = args[:path] || SCHEMA_PATH
      db        = Sequel.connect(DatabaseTaskHelper.connection(DEV, 'development'))

      db.extension :schema_dumper
      schema = db.dump_schema_migration
      bad    = /\s*create_table\(:schema(.*) do\s+\w+(.*)\s+(primary_key(.*))?\s+end/
      schema.gsub!(bad, '')

      File.open("#{path}/#{timestamp}_schema.rb", 'w+') {|file| file << schema }
    end
  end

  namespace :development do 
    client = Mysql2::Client.new(DEV)

    desc 'Create development database'
    task :create do 
      begin
        client.query('CREATE DATABASE development')
      rescue Mysql2::Error
        puts "Development database exists...".blue
      end
    end

    desc 'Migrate development database'
    task :migrate, [:PATH] => ['db:development:create'] do |t, args|
      path = args[:PATH] || MIGRATION_PATH
      Sequel.connect(DatabaseTaskHelper::connection(DEV, 'development')) do |db|
        Sequel::Migrator.run(db, path)
      end
      puts "Development database migrated successfully...".green
    end

    desc 'Drop development database'
    task :drop do 
      begin
        client.query('DROP DATABASE development')
        puts "Development database was deleted successfully.".green
      rescue Mysql2::Error
        puts "Development database was not found.".yellow
      end
    end
  end

  namespace :test do 
    client = Mysql2::Client.new(TEST)

    desc 'Create test database'
    task :create do 
      begin
        client.query('CREATE DATABASE test')
      rescue Mysql2::Error
        puts "Test database exists...".blue
      end
    end

    desc 'Migrate test database'
    task :migrate, [:PATH] => ['db:test:create'] do |t, args|
      path = args[:path] || MIGRATION_PATH
      Sequel.connect(DatabaseTaskHelper.connection(TEST, 'test')) do |db|
        Sequel::Migrator.run(db, path)
      end
      puts "Test database migrated successfully...".green
    end

    desc 'Drop the test database' 
    task :drop do 
      begin 
        client.query('DROP DATABASE test')
        puts "Test database was deleted successfully.".green
      rescue Mysql2::Error
        puts "Test database was not found.".yellow 
      end
    end

    desc 'Clean test database and update schema'
    task :prepare do 
      client.query('DROP DATABASE test')
      Rake::Task['db:test:create'].invoke
      Rake::Task['db:test:migrate'].invoke(SCHEMA_PATH)
      puts "Success!".green
    end
  end

  namespace :production do 
    client = Mysql2::Client.new(PRODUCTION)

    desc 'Create production database'
    task :create do 
      begin
        client.query('CREATE DATABASE production')
      rescue Mysql2::Error
        puts "Production database exists...".blue
      end
    end

    desc 'Migrate production database'
    task :migrate, [:PATH] => ['db:production:create'] do |t, args|
      path = args[:path] || MIGRATION_PATH
      Sequel.connect(DatabaseTaskHelper.connection(PRODUCTION, 'production')) do |db|
        Sequel::Migrator.run(db, path)
      end
      puts "Production database migrated successfully...".green
    end

    desc 'Drop production database'
    task :drop do  
      puts "Dropping the production database can cause irretrievable data loss. Proceed? (Anything but 'yes' will cancel request)"
      answer = STDIN.gets
      if answer.chomp == 'yes'
        begin
          client.query('DROP DATABASE production')
          puts 'Production database was deleted successfully.'.green
        rescue
          puts 'Production database was not found.'.yellow
        end
      else
        puts 'Request canceled'.yellow
      end
    end
  end
end