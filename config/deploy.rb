# Require the recipes you need, comment out the ones you don't
load "config/recipes/base"
#load "config/recipes/check"
#load "config/recipes/asset_pipeline"
#load "config/recipes/backup"
#load "config/recipes/carrierwave"
#load "config/recipes/logrotate"
#load "config/recipes/logs"
#load "config/recipes/passenger"
load "config/recipes/postgresql"
#load "config/recipes/pry"
#load "config/recipes/nginx"
#load "config/recipes/nodejs"
#load "config/recipes/rails_config"
#load "config/recipes/rbenv"
#load "config/recipes/resque"
#load "config/recipes/sidekiq"
#load "config/recipes/unicorn"

require "bundler/capistrano"
require "whenever/capistrano"

set :server_ip, "107.170.134.125"
server "#{server_ip}", :web, :app, :db, primary: true

set :application, "idigitallsports"
set :user, "root"
set :deploy_to, "/home/apps/#{application}"

set :deploy_via, :remote_cache

set :use_sudo, false

set :whenever_command, "bundle exec whenever"
# SCM
set :scm, "git"
set :repository, "git@github.com:cubetaj/idigitallsports.git"
set :branch, "master"

# RVM
set :rvm_ruby_string, 'ruby-2.1.3@players-brand'
set :rvm_type, :system

# Resque
role :resque_worker, "#{server_ip}"
role :resque_scheduler, "#{server_ip}"
set :workers, { '*' => 2 }
# Uncomment this line if your workers need access to the Rails environment:
set :resque_environment_task, true

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :unicorn_init_initial_path, "#{current_path}/config/unicorn_init.sh"
set :unicorn_init_system_path, "/etc/init.d/unicorn_#{application}"

after "deploy", "deploy:cleanup" # keep only the last 5 releases
after "deploy:update_code", "deploy:migrate"

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{unicorn_init_initial_path} #{unicorn_init_system_path}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml.sample"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  task :set_file_permissions, roles: :app do
    run "chmod +x #{unicorn_init_initial_path}"
    run "chmod +x #{unicorn_init_system_path}"
  end
  after "deploy:create_symlink", "deploy:set_file_permissions"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end

# Resque
#after "deploy:restart", "resque:restart" # FIXME: re-enable when Resque is fixed

callback = callbacks[:after].find{|c| c.source == "deploy:assets:precompile" }
callbacks[:after].delete(callback)
after 'deploy:update_code', 'deploy:assets:precompile' unless fetch(:skip_assets, false)

# Resque
after "deploy:restart", "resque:restart"
# Must be at the bottom of the file
require 'rvm/capistrano' # RVM with Capistrano https://github.com/wayneeseguin/rvm-capistrano