require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GolCommu
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.i18n.default_locale = :ja

    config.generators do |g|
      g.javascripts false
      g.stylesheets false
      g.test_framework :rspec,
            view_specs: false,
            helper_specs: false,
            controller_specs: false,
            routing_specs: false
    end

    # 認証トークンをremoteフォームに埋め込む
    config.action_view.embed_authenticity_token_in_remote_forms = true

    config.autoload_paths += %W(#{config.root}/lib)
    config.enable_dependency_loading = true
  end
end
