set :branch, 'staging'

server '', user: (ENV['USER'] || 'poweruser'), roles: %w{web db app}

set :rails_env, 'staging'
