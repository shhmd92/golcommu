app_path = "/var/www/rails/golcommu"

worker_processes 2

working_directory "#{app_path}/current"

listen "#{app_path}/shared/tmp/sockets/unicorn.sock"

timeout 60

pid "#{app_path}/shared/tmp/pids/unicorn.pid"

stderr_path "#{app_path}/shared/log/unicorn.stderr.log"
stdout_path "#{app_path}/shared/log/unicorn.stdout.log"

preload_app true
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

check_client_connection false

run_once = true

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!

  if run_once
    run_once = false
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => e
      logger.error e
    end
  end
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end