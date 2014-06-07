require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Canto
  class Application < Rails::Application

    # Resolve some issues with 
    config.action_view.field_error_proc = Proc.new do |html_tag, instance| 
      "<div class=\"has-error form-group\">#{html_tag}</div>".html_safe
    end

    # Default time zone is Pacific (west-coast US)
    # Settings in config/environments/* take precedence over those
    # specified here.
    config.time_zone = 'Pacific Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
