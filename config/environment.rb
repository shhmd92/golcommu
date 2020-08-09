require_relative 'application'

notify = -> (e) do
  begin
    Rollbar.with_config(use_async: false) do
      Rollbar.error(e)
    end
  rescue
    Rails.logger.error 'Synchronous Rollbar notification failed.  Sending async to preserve info'
    Rollbar.error(e)
  end
end

begin
  Rails.application.initialize!
rescue Exception => e
  notify.call(e)
  raise
end
