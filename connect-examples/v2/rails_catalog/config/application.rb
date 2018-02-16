require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsCatalog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.


    error_msg = "\n\n#{'*'*110}\n\n**** Fatal config error: Set your required env vars, or '.env' file. (See README.rdoc and '.env.sample')\n\n#{'*'*110}\n"
    raise error_msg unless Rails.application.secrets.square_application_id.present? && Rails.application.secrets.square_access_token.present?

    SquareConnect.configure do |config|
      # Configure OAuth2 access token for authorization: oauth2
      config.access_token = Rails.application.secrets.square_access_token
    end
  end
end
