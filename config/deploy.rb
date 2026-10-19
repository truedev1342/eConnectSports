lock '~> 3.19.0'

set :application, 'idigitallsports'
set :repo_url, 'git@github.com:cubetaj/idigitallsports.git'
set :branch, ENV.fetch('BRANCH', 'main')

set :deploy_to, "/home/apps/#{fetch(:application)}"
set :keep_releases, 5

set :rbenv_type, :system
set :rbenv_ruby, File.read('.ruby-version').strip

# Written once into shared/ and symlinked into each release, so credentials
# never travel with the checkout.
set :linked_files, %w[.env.production config/fog_credentials.yml config/aweber.yml]
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets public/system public/assets]

# Resque
set :workers, { '*' => 2 }
set :resque_environment_task, true

set :whenever_command, 'bundle exec whenever'

set :ssh_options, forward_agent: true

namespace :deploy do
  desc 'Restart the unicorn master'
  task :restart do
    on roles(:app) do
      execute "/etc/init.d/unicorn_#{fetch(:application)} restart"
    end
  end

  desc 'Warn when the local branch is behind the remote'
  task :check_revision do
    run_locally do
      local = capture(:git, 'rev-parse', 'HEAD').strip
      remote = capture(:git, 'rev-parse', "origin/#{fetch(:branch)}").strip
      unless local == remote
        error "HEAD is not the same as origin/#{fetch(:branch)}; run `git push` first."
        exit 1
      end
    end
  end

  before :starting, :check_revision
  after :publishing, :restart
  after :restart, 'resque:restart'
end
