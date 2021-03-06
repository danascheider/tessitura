require 'mysql2'
require 'sequel'

Sequel.extension :migration

DATABASE       = 'mysql2://travis@127.0.0.1:3306/test'
DB ||= Sequel.connect(DATABASE)

namespace :travis do 
  Cucumber::Rake::Task.new do |task|
    task.cucumber_opts = '--tags ~@integration'
  end

  desc 'Migrate the database'
  task :migrate do
    Sequel::Migrator.run(DB, MIGRATION_PATH)
  end

  desc 'Create, migrate, and clean the test database'
  task :prepare do 
    client = Mysql2::Client.new({adapter: 'mysql2', username: 'travis', host: '127.0.0.1', port: 3306})
    client.query('DROP DATABASE test;') rescue nil
    client.query('CREATE DATABASE test;')
    Rake::Task['travis:migrate'].invoke
  end

  desc 'Run RSpec and Cucumber tests'
  task :run do 
    Rake::Task['travis:migrate'].invoke
    Rake::Task['spec'].invoke
    Rake::Task['travis:cucumber'].invoke
  end
end
