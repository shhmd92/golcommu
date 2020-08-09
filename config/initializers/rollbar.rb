Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']

  config.enabled = %w[production staging].include?(Rails.env)

  config.environment = ENV['ROLLBAR_ENV'].presence || Rails.env
end
