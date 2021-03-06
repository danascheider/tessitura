require 'sinatra/base'
require 'sequel'
require 'rack/cors'
require 'rack/ssl-enforcer'
require 'reactive_support/core_ext/object'
require 'reactive_extensions/object'
require 'reactive_extensions/hash'
require 'reactive_extensions/array'
require 'json'
require 'geofilter'

require File.expand_path('../../config/settings', __FILE__)

require File.expand_path '../models/fach.rb', __FILE__
require File.expand_path '../models/audition.rb', __FILE__
require File.expand_path '../models/listing.rb', __FILE__
require File.expand_path '../models/organization.rb', __FILE__
require File.expand_path '../models/church.rb', __FILE__
require File.expand_path '../models/program.rb', __FILE__
require File.expand_path '../models/season.rb', __FILE__
require File.expand_path '../models/task.rb', __FILE__
require File.expand_path '../models/task_list.rb', __FILE__
require File.expand_path '../models/user.rb', __FILE__

require File.expand_path '../routes/routing.rb', __FILE__
require File.expand_path '../routes/filters.rb', __FILE__
require File.expand_path '../routes/admin_routes.rb', __FILE__
require File.expand_path '../routes/fach_routes.rb', __FILE__
require File.expand_path '../routes/geofilter_routes.rb', __FILE__
require File.expand_path '../routes/listing_routes.rb', __FILE__
require File.expand_path '../routes/organization_routes.rb', __FILE__
require File.expand_path '../routes/church_routes.rb', __FILE__
require File.expand_path '../routes/program_routes.rb', __FILE__
require File.expand_path '../routes/season_routes.rb', __FILE__
require File.expand_path '../routes/task_routes.rb', __FILE__
require File.expand_path '../routes/user_routes.rb', __FILE__

class Tessitura < Sinatra::Base

  set :static, true

  register Sinatra::Tessitura::Routing::Filters
  register Sinatra::Tessitura::Routing::AdminRoutes
  register Sinatra::Tessitura::Routing::ListingRoutes
  register Sinatra::Tessitura::Routing::OrganizationRoutes
  register Sinatra::Tessitura::Routing::ChurchRoutes
  register Sinatra::Tessitura::Routing::ProgramRoutes
  register Sinatra::Tessitura::Routing::SeasonRoutes
  register Sinatra::Tessitura::Routing::TaskRoutes
  register Sinatra::Tessitura::Routing::UserRoutes
  register Sinatra::Tessitura::Routing::FachRoutes
  register Sinatra::Tessitura::Routing::GeoFilterRoutes

  not_found do 
    [404, '' ]
  end

  post '/login' do
    login
  end

  get '/ping' do 
    Sequel.extension :migration, :core_extensions
    db_writable = false

    DB.transaction(rollback: :always) do 
      fach = Fach.new()

      begin
        db_writable = true if fach.save(validate: false)
      rescue Sequel::UniqueConstraintViolation
        db_writable = true
      end
    end

    {
      :environment    => ENV['RACK_ENV'],
      :db_url         => DB.url,
      :schema_current => Sequel::Migrator.is_current?(DB, File.expand_path('../../db/migrate', __FILE__)),
      :db_online      => !!DB,
      :db_readable    => !!User.first,
      :db_writable    => db_writable
    }.to_json
  end
end
