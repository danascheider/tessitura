# Set Rack environment
rack_env = ENV['RACK_ENV'] || 'production'
@dir = rack_env == 'production' ? '/var/www/canto/' : `pwd`.chomp

worker_processes 2
working_directory @dir

timeout 30

# Specify path to Unicorn for nginx.conf
listen "#{@dir}tmp/sockets/unicorn.sock", backlog: 64

# Set process ID path
pid "#{@dir}tmp/pids/unicorn.pid"

# Set log file paths
stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"