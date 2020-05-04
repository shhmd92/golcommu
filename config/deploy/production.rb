set :branch, 'master'

server '18.178.138.177', 
  user: 'sho',
  roles: %w[web app db],
  port: 22,
  ssh_options: {
    user: 'sho',
    keys: [File.expand_path('~/.ssh/golcommu_key_rsa')],
    forward_agent: true,
  }