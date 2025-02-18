require 'resque/tasks'
require 'resque/scheduler/tasks'

task 'resque:setup' => :environment do
  ENV['QUEUE'] ||= '*'

  # Hand each forked worker its own database connection. Establishing the
  # connection before the fork left parent and children sharing one socket.
  Resque.before_fork = proc { ActiveRecord::Base.connection_handler.clear_all_connections! }
  Resque.after_fork = proc { ActiveRecord::Base.establish_connection }
end

task 'resque:scheduler_setup' => 'resque:setup'
