set :stage, :production
set :rails_env, 'production'
set :deploy_to, '/var/www/fc2play'
set :config_path, 'config'
set :unicorn_pid, -> { File.join(shared_path, 'tmp', 'pids', 'fc2play.pid') }
set :unicorn_config_path, 'config/unicorn.rb'
set :unicorn_rack_env, 'production'
set :unicorn_restart_sleep_time, 3
server 'fc2play', roles: %w(web app db)
