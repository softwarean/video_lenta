lock '3.2.1'

require 'capistrano-db-tasks'

set :undev_ruby_version, '2.0.0-p247'

set :application, ''

set :repo_url, ''
set :scm, :git

set :keep_releases, 5

set :deploy_to, ''

set :pty, true

set :ssh_options, { forward_agent: true }

set :linked_dirs, fetch(:linked_dirs) + ["public/system", "tmp", "public/uploads"]

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db do
    on roles :app do
      execute "ln -nfs #{fetch(:release_path)}/config/database.example.yml #{fetch(:release_path)}/config/database.yml"
    end
  end

  task :start do
    on release_roles :all do
      start "#{fetch(:application)}_unicorn"
    end
  end

  task :stop do
    on release_roles :all do
      stop "#{fetch(:application)}_unicorn"
    end
  end

  task :restart do
    on release_roles :all do
      restart "#{fetch(:application)}_unicorn"
    end
  end

  after :publishing, :restart
end

namespace :ckeditor do
  task :copy_nondigest_assets do
    on release_roles :app do
      within release_path do
        with rails_env: fetch(:rails_env), path: fetch(:default_env)[:path] do
          rake 'ckeditor:create_nondigest_assets'
        end
      end
    end
  end
end

namespace :resque do
  task :restart do
    on release_roles :all do
      restart "resque_worker"
    end
  end
end

namespace :broadcasting_status_updater do
  task :restart do
    on release_roles :all do
      restart "broadcasting_status_updater"
    end
  end
end

before 'deploy:assets:precompile', 'deploy:symlink_db'
after 'deploy:assets:precompile', 'ckeditor:copy_nondigest_assets'
after :deploy, "resque:restart"
after :deploy, "broadcasting_status_updater:restart"
