# config valid for current version and patch releases of Capistrano
lock '3.13.0'

set :application, 'golcommu'

set :repo_url, 'git@github.com:shhmd92/golcommu.git'

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :rbenv_type, :user
set :rbenv_ruby, '2.7.0'

set :ssh_options, auth_methods: ['publickey'],
                  keys: ['~/.ssh/GolCommu-ssh-key.pem']

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

set :linked_files, %w{ config/master.key }

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'upload master.key'
  task :upload do
    on roles(:app) do |_host|
      execute "mkdir -p #{shared_path}/config" if test "[ ! -d #{shared_path}/config ]"
    end
  end
  before :starting, 'deploy:upload'
  after :finishing, 'deploy:cleanup'
end