APP_PATH   = "#{File.dirname(__FILE__)}/.." unless defined?(APP_PATH)
RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)
RAILS_ENV  = ENV['RAILS_ENV'] || 'development'

worker_processes 3

listen '/tmp/unicorn.sock'
pid 'tmp/pids/unicorn.pid'

preload_app true

timeout 60
working_directory APP_PATH

# logのpath
stderr_path "#{RAILS_ROOT}/log/unicorn_error.log"
stdout_path "#{RAILS_ROOT}/log/unicorn_access.log"

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = APP_PATH + '/Gemfile'
end

before_fork do |server, _worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  unless old_pid == server.pid
    begin
      Process.kill :QUIT, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
