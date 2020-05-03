server '18.178.138.177', 
  user: 'sho', 
  roles: %w{app db web},
  ssh_options: {
    keys: ["#{ENV.fetch('PRODUCTION_SSH_KEY')}"], 
    forward_agent: true,
    auth_methods: %w(publickey),
    port: 22
  }