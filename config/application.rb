require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.

# If you precompile assets before deploying to production, use this line
# Bundler.require(*Rails.groups(assets: %w(development test)))
# If you want your assets lazily compiled in production, use this line
Bundler.require(*Rails.groups, :assets)

module WolfRails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'UTC'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    
    # Use custom exception handler
    config.exceptions_app = self.routes
    
    # Fix rails generator because issue with Devise gem
    # https://github.com/plataformatec/responders/issues/94#issuecomment-59538373
    config.app_generators.scaffold_controller :scaffold_controller
  end
end
