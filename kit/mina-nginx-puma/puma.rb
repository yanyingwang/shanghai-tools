# #{deploy_to}/#{shared_path}/config/puma.rb

# Change to match your CPU core count
workers 1

# Min and Max threads per worker
threads 1, 6

mina_dir = File.expand_path("../../..", __FILE__)
app_dir = "#{mina_dir}/current"
shared_dir = "#{mina_dir}/shared"

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
bind "unix://#{shared_dir}/tmp/sockets/puma.sock"

# Logging
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_dir}/tmp/pids/puma.pid"
state_path "#{shared_dir}/tmp/sockets/puma.state"
activate_control_app "unix://#{shared_dir}/tmp/sockets/pumactl.sock"


on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
