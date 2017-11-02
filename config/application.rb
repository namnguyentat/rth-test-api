require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Wonder
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.time_zone = 'Hanoi'

    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app', 'lib')
    config.autoload_paths << Rails.root.join('app', 'concepts')
    config.autoload_paths << Rails.root.join('app', 'concepts', 'lib')
    config.autoload_paths << Rails.root.join('app', 'graph')
    config.autoload_paths << Rails.root.join('app', 'graph', 'lib')
    config.autoload_paths << Rails.root.join('app', 'graph', 'types')
    config.autoload_paths << Rails.root.join('app', 'graph', 'loader')

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      authentication: :plain,
      address: 'smtp.mailgun.org',
      port: 587,
      user_name: ENV['EMAIL_SENDER'],
      password: ENV['EMAIL_PASSWORD']
    }

    # LOGGING
    # config.lograge.enabled = true
    # config.lograge.formatter = Lograge::Formatters::Logstash.new if !(Rails.env.development? || Rails.env.test?)

    # config.lograge.custom_options = lambda do |event|
    #   options = event.payload.slice(:request_id, :user_id, :remote_ip)
    #   options[:time] = event.time.to_s
    #   options[:params] = event.payload[:params].except("controller", "action").to_s
    #   options[:search] = event.payload[:searchkick_runtime] if event.payload[:searchkick_runtime].to_f > 0
    #   options[:env] = Rails.env
    #   options[:type] = 'api-request'
    #   options
    # end
  end
end
