if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_directory = ENV['AWS_S3_BUCKET']
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_S3_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_S3_SECRET_ACCESS_KEY'],
      region:                ENV['AWS_S3_REGION'],
      path_style:            true
    }
  end
end