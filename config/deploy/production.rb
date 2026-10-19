server ENV.fetch('DEPLOY_HOST', '107.170.134.125'),
       user: ENV.fetch('DEPLOY_USER', 'deploy'),
       roles: %w[app web db resque_worker resque_scheduler]

set :rails_env, 'production'
