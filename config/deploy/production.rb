server '18.178.138.177', 
  user: 'sho', 
  roles: %w{app db web},
  ssh_options: {
    keys: [File.expand_path('~/.ssh/id_rsa_9a588f9e84fea8deef94095257cfa350')],
    forward_agent: true,
    auth_methods: %w(publickey),
    port: 22
  }