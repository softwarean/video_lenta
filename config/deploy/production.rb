require "capistrano/rsync"

# hack for cap rsync to work with cap3
namespace :rsync do
  task :set_current_revision do
  end
end

set :rsync_cache, nil

set :rsync_options, %w[--recursive --verbose]

set :branch, 'master'

set :scm, 'rsync'
set :repo_url, '.'

server '', user: (ENV['USER'] || 'poweruser'), roles: %w{web db app}

set :rails_env, 'production'
