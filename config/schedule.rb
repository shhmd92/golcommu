set :output, 'log/crontab.log'
set :environment, ENV['RAILS_ENV']

every 1.day do
  rake "create_notification:create_event_close_notification"
end
