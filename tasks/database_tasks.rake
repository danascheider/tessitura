require 'sqlite3'
require 'sequel'

DB_PATH = File.expand_path('../../db', __FILE__)
Sequel.extension :migration

namespace :db do 
  desc 'Create all databases except those that currently exist'
  task :create do 
    Rake::Task['db:development:create'].invoke
    Rake::Task['db:production:create'].invoke
    Rake::Task['db:test:create'].invoke
  end

  namespace :development do 
    desc 'Create development database'
    task :create do 
      if File.exists?(filename = "#{DB_PATH}/development.sqlite3")
        puts "Development database exists".yellow
      else
        dev_db = SQLite3::Database.new filename unless File.exists?(filename)
        puts "Development database created at #{filename}".green
      end
    end
  end

  namespace :test do 
    desc 'Create test database'
    task :create do 
      if File.exists?(filename = "#{DB_PATH}/test.sqlite3")
        puts "Test database exists".yellow
      else
        test_db = SQLite3::Database.new filename
        puts "Test database created at #{filename}".green
      end
    end
  end

  namespace :production do 
    desc 'Create production database'
    task :create do 
      if File.exists?(filename = "#{DB_PATH}/production.sqlite3")
        puts "Production database exists".yellow
      else
        production_db = SQLite3::Database.new "#{DB_PATH}/production.sqlite3"
        puts "Production database created at #{DB_PATH}/production.sqlite3".green
      end
    end
  end

  desc 'Create new migration, required arg NAME, default PATH /db/migrate'
  task :create_migration, [:NAME, :PATH] do |t, args|
    path = args[:path] || File.expand_path('../../db/migrate', __FILE__)
    Dir.mkdir(path) unless Dir.exists?(path)

    File.open("#{path}/#{Time.now.getutc.to_s.gsub(/\D/, '')}_#{args[:NAME]}.rb", 'w+') do |file|
      file.write <<-EOF
migration "#{args[:NAME]}" do 
  up do
  end

  down do 
  end
end
EOF
    end
  end

  desc 'Migrate all databases'
  task :migrate => ['db:create'] do |t|

    db_path = File.expand_path('../../db',__FILE__)
    migration_path = "#{db_path}/migrate"

    Dir.glob("#{db_path}/*.sqlite3").each do |file|
      Sequel.sqlite(file) do |db|
        Sequel::Migrator.run(db, migration_path)
      end
    end
  end
end