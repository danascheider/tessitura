module Sinatra
  module Canto
    module Routing
      module TestRoutes
        def self.registered(app)
          app.post '/test/prepare' do 
            require 'mysql2'
            require 'json'

            yaml_data = DatabaseTaskHelper.get_yaml(File.expand_path('../../../config/database.yml', __FILE__))
            client = Mysql2::Client.new(yaml_data['defaults'])

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

            seeds = JSON.parse(File.read(File.expand_path('../../../db/seeds.json', __FILE__)), symbolize_names: true)
            seeds.to_h
            # user = User.try_rescue(:create, seeds[:user])

            # seeds[:tasks].each do |data|
            #   data[task_list_id: user.default_task_list]
            #   Task.try_rescue(:create, data)
            # end 
          end
        end
      end
    end
  end
end