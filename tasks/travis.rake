require 'mysql2'
require 'sequel'

Sequel.extension :migration

MIGRATION_PATH = File.expand_path('db/migrate')
DATABASE = 'mysql2://travis@127.0.0.1:3306/test'
DB = Sequel.connect(DATABASE)

namespace :travis do 
  desc 'Migrate'
  task :migrate do
    Sequel::Migrator.run(DB, MIGRATION_PATH)
  end

  task :prepare do 
    client = Mysql2::Client.new({adapter: 'mysql2', username: 'travis', host: '127.0.0.1', port: 3306})
    client.query('DROP DATABASE test IF EXISTS test;')
    client.query('CREATE DATABASE test;')
    Rake::Task['travis:migrate'].invoke
  end
end