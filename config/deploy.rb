# config valid for current version and patch releases of Capistrano
lock '3.13.0'

set :application, 'golcommu'

set :repo_url, 'git@github.com:shhmd92/golcommu.git'

set :deploy_to, '/var/www/rails/golcommu'

set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system',
  'public/uploads'
)

set :linked_files, fetch(:linked_files, []).push(
  'config/master.key',
  '.env'
)

set :rbenv_type, :user
set :rbenv_ruby, '2.7.0'

set :log_level, :debug

set :ssh_options, auth_methods: ['publickey'],
                  keys: ['~/.ssh/GolCommu-ssh-key.pem']

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }

set :keep_releases, 5

set :bundle_flags,      '--quiet'
set :bundle_path,       nil
set :bundle_without,    nil

namespace :deploy do
  desc 'Config bundler'
  task :config_bundler do
    on roles(/.*/) do
      within release_path do
        execute :bundle, :config, '--local deployment true'
        execute :bundle, :config, '--local without "development test"'
        execute :bundle, :config, "--local path #{shared_path.join('bundle')}"
      end
    end
  end

  desc 'upload config'
  task :upload do
    on roles(:app) do |_host|
      execute "mkdir -p #{shared_path}/config" if test "[ ! -d #{shared_path}/config ]"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      invoke 'unicorn:restart'
    end
  end

  before :starting, 'deploy:upload'
  after :finishing, 'deploy:cleanup'
  after :publishing, :restart
end