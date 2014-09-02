require 'sqlite3'
require 'sequel'

DB_PATH = File.expand_path('../../db', __FILE__)

namespace :db do 
  namespace :development do 
    desc 'Create development database'
    task :create do 
      dev_db = SQLite3::Database.new "#{DB_PATH}/development.sqlite3"
      puts "Development database created at #{DB_PATH}/development.sqlite3"
    end
  end

  namespace :test do 
    desc 'Create test database'
    task :create do 
      test_db = SQLite3::Database.new "#{DB_PATH}/test.sqlite3"
      puts "Test database created at #{DB_PATH}/test.sqlite3"
    end
  end

  namespace :production do 
    desc 'Create production database'
    task :create do 
      path = 
      production_db = SQLite3::Database.new "#{DB_PATH}/production.sqlite3"
      puts "Production database created at #{DB_PATH}/production.sqlite3"
    end
  end

  desc 'Create new migration, required arg NAME, default PATH /db/migrate'
  task :create_migration, [:NAME, :PATH] do |t, args|
    path = args[:path] || File.expand_path('../../db/migrate', __FILE__)
    Dir.mkdir(path) unless Dir.exists?(path)
    filename = "#{path}/#{Time.now.getutc.to_s.gsub(/\D/, '')}_#{args[:NAME]}.rb"

    File.open(filename, 'w+') do |file|
      file.write <<-EOF
Sequel.migration do 
  up do
  end

  down do 
  end
end
EOF
    end
  end


  desc 'Migrate all databases'
  task :migrate => ['db:development:create', 'db:test:create', 'db:production:create'] do 
    puts 'bar'
  end
end