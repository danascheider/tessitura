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

def connection(hash, env)
  "#{hash[:adapter]}://#{hash[:username]}:#{hash[:password]}@#{hash[:host]}:#{hash[:port]}/#{env}"
end

namespace :db do 
  desc 'Create all databases except those that currently exist'
  task :create do 
    Rake::Task['db:development:create'].invoke
    Rake::Task['db:production:create'].invoke
    Rake::Task['db:test:create'].invoke
    puts "Done!".green
  end

  desc 'Migrate all databases'
  task :migrate do |t|
    Rake::Task['db:development:migrate'].invoke 
    Rake::Task['db:test:migrate'].invoke
    Rake::Task['db:production:migrate'].invoke
    puts "Success!".green
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
    task :migrate => ['db:development:create'] do 
      Sequel.connect(connection(DEV, 'development')) do |db|
        Sequel::Migrator.run(db, MIGRATION_PATH)
      end
    end
  end

  namespace :test do 
    desc 'Create test database'
    task :create do 
      client = Mysql2::Client.new(TEST)
      begin
        client.query('CREATE DATABASE test')
      rescue Mysql2::Error
        puts "Test database exists...".blue
      end
    end

    desc 'Migrate test database'
    task :migrate => ['db:test:create'] do 
      Sequel.connect(connection(TEST, 'test')) do |db|
        Sequel::Migrator.run(db, MIGRATION_PATH)
      end
    end
  end

  namespace :production do 
    desc 'Create production database'
    task :create do 
      client = Mysql2::Client.new(PRODUCTION)
      begin
        client.query('CREATE DATABASE production')
      rescue Mysql2::Error
        puts "Production database exists...".blue
      end
    end

    desc 'Migrate production database'
    task :migrate => ['db:production:create'] do 
      Sequel.connect(connection(PRODUCTION, 'production')) do |db|
        Sequel::Migrator.run(db, MIGRATION_PATH)
      end
    end
  end

  desc 'Create new migration, required arg NAME, default PATH /db/migrate'
  task :create_migration, [:NAME, :PATH] do |t, args|
    path = args[:path] || File.expand_path('../../db/migrate', __FILE__)
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
    puts "Migration created at #{MIGRATION_PATH}/#{name}".green
  end
end