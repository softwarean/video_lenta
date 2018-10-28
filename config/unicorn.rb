worker_processes (ENV['UNICORN_WORKERS'] || 1).to_i

working_directory ENV['UNICORN_HOME']

listen (ENV['UNICORN_PORT'] || 3000).to_i, backlog: (ENV['UNICORN_BACKLOG'] || 100).to_i

timeout (ENV['UNICORN_TIMEOUT'] || 60).to_i

pid ENV['UNICORN_PIDFILE']

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
