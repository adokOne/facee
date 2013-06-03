# Set your full path to application.
app_path = ENV['RAILS_ROOT'] || "/home/adok/dai/current"

# Set unicorn options
worker_processes 3
preload_app true
timeout 180
listen  "#{app_path}/tmp/sockets/unicorn.sock", :backlog => 64

user "adok", "adok"
working_directory app_path
rails_env = ENV['RAILS_ENV'] || 'production'

# Set master PID location
pid "#{app_path}/tmp/pids/unicorn.pid"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
      puts "Old master alerady dead"
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
