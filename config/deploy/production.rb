server '18.178.138.177', 
  user: 'ec2-user', 
  roles: %w{app db web},
  ssh_options: {
    keys: [File.expand_path('~/.ssh/golcommu_key_rsa')],
    forward_agent: true,
    auth_methods: %w(publickey),
    port: 22
  }