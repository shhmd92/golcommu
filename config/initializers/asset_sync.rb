if defined?(AssetSync)
  AssetSync.configure do |config|
    config.fog_provider = 'AWS'
    config.fog_directory = ENV['AWS_ASSETS_FOG_DIRECTORY']
    config.aws_access_key_id = ENV['AWS_S3_ACCESS_KEY_ID']
    config.aws_secret_access_key = ENV['AWS_S3_SECRET_ACCESS_KEY']
    config.aws_session_token = ENV['AWS_SESSION_TOKEN'] if ENV.key?('AWS_SESSION_TOKEN')
    config.fog_region = ENV['AWS_S3_REGION']
  end
end
