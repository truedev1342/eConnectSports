set_default(:postgresql_host, "localhost")
set_default(:postgresql_user) { application }
set_default(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
set_default(:postgresql_database) { "#{application}_production" }
set_default(:postgresql_dump_path) { "#{current_path}/tmp" }
set_default(:postgresql_dump_file) { "#{application}_dump.sql" }
set_default(:postgresql_heroku_dump_file) { "#{application}_latest.dump" }
set_default(:postgresql_local_dump_path) { File.expand_path("../../../tmp", __FILE__) }
set_default(:postgresql_pid) { "/var/run/postgresql/9.1-main.pid" }

namespace :postgresql do
  desc "Install the latest stable release of PostgreSQL."
  task :install, roles: :db, only: {primary: true} do
    run "#{sudo} add-apt-repository -y ppa:pitti/postgresql"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install postgresql libpq-dev"
  end
  after "deploy:install", "postgresql:install"

  desc "Create a database for this application."
  task :create_database, roles: :db, only: {primary: true} do
    run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
    run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
  end
  after "deploy:setup", "postgresql:create_database"

  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "postgresql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "postgresql:symlink"

  desc "database console"
  task :console do
    auth = capture "cat #{shared_path}/config/database.yml"
    puts "PASSWORD::: #{auth.match(/password: (.*$)/).captures.first}"
    hostname = find_servers_for_task(current_task).first
    exec "ssh #{hostname} -t 'source ~/.zshrc && psql -U #{application} #{postgresql_database}'"
  end


  namespace :local do
    desc "Download remote database to tmp/"
    task :download do
      dumpfile = "#{postgresql_local_dump_path}/#{postgresql_dump_file}.gz"
      get "#{postgresql_dump_path}/#{postgresql_dump_file}.gz", dumpfile
    end

    desc "Restores local database from temp file"
    task :restore do
      auth = YAML.load_file(File.expand_path('../../database.yml', __FILE__))
      dev  = auth['development']
      user, pass, database, host = dev['username'], dev['password'], dev['database'], dev['host']
      dumpfile = "#{postgresql_local_dump_path}/#{postgresql_dump_file}"
      system "gzip -cd #{dumpfile}.gz > #{dumpfile} && cat #{dumpfile} | psql -U #{user} -h #{host} #{database}"
    end

    desc "Dump remote database and download it locally"
    task :localize do
      remote.dump
      download
    end

    desc "Dump remote database, download it locally and restore local database"
    task :sync do
      localize
      restore
    end
  end

  namespace :remote do
    desc "Dump remote database"
    task :dump do
      dbyml = capture "cat #{shared_path}/config/database.yml"
      info  = YAML.load dbyml
      db    = info[stage.to_s]
      user, pass, database, host = db['username'], db['password'], db['database'], db['host']
      commands = <<-CMD
        pg_dump -U #{user} -h #{host} #{database} | \
        gzip > #{postgresql_dump_path}/#{postgresql_dump_file}.gz
      CMD
      run commands do |ch, stream, data|
        if data =~ /Password/
          ch.send_data("#{pass}\n")
        end
      end
    end

    desc "Uploads local sql.gz file to remote server"
    task :upload do
      dumpfile = "#{postgresql_local_dump_path}/#{postgresql_dump_file}.gz"
      upfile   = "#{postgresql_dump_path}/#{postgresql_dump_file}.gz"
      put File.read(dumpfile), upfile
    end

    desc "Restores remote database"
    task :restore do
      dumpfile = "#{postgresql_dump_path}/#{postgresql_dump_file}"
      gzfile   = "#{dumpfile}.gz"
      dbyml    = capture "cat #{shared_path}/config/database.yml"
      info     = YAML.load dbyml
      db       = info['production']
      user, pass, database, host = db['username'], db['password'], db['database'], db['host']

      commands = <<-CMD
        gzip -cd #{gzfile} > #{dumpfile} && \
        cat #{dumpfile} | \
        psql -U #{user} -h #{host} #{database}
      CMD

      run commands do |ch, stream, data|
        if data =~ /Password/
          ch.send_data("#{pass}\n")
        end
      end
    end

    desc "Uploads and restores remote database"
    task :sync do
      upload
      restore
    end

    namespace :heroku do
      desc "Dump db from Heroku using Heroku toolbelt"
      task :dump do
        postgresql_heroku_local_dump_file_path = "#{postgresql_local_dump_path}/#{postgresql_heroku_dump_file}"

        run_locally 'heroku pgbackups:capture'
        run_locally "curl -o #{postgresql_heroku_local_dump_file_path} `heroku pgbackups:url`"
        run_locally "cat #{postgresql_heroku_local_dump_file_path} | gzip > #{postgresql_heroku_local_dump_file_path}.gz"
        run_locally "rm #{postgresql_heroku_local_dump_file_path}"
      end

      desc "Upload Heroku-made db dump to remote server"
      task :upload do
        postgresql_heroku_local_dump_file_path = "#{postgresql_local_dump_path}/#{postgresql_heroku_dump_file}"

        dumpfile = "#{postgresql_heroku_local_dump_file_path}.gz"
        upfile   = "#{postgresql_dump_path}/#{postgresql_heroku_dump_file}.gz"
        put File.read(dumpfile), upfile
      end

      desc "Restore Heroku-made db dump on remote server"
      task :restore do
        dumpfile = "#{postgresql_dump_path}/#{postgresql_heroku_dump_file}"
        gzfile   = "#{dumpfile}.gz"
        dbyml    = capture "cat #{shared_path}/config/database.yml"
        info     = YAML.load dbyml
        db       = info['production']
        user, pass, database, host = db['username'], db['password'], db['database'], db['host']

        # last command allows pg_restore to complete successfully (0) or with warnings (1)
        commands = <<-CMD
        gzip -cd #{gzfile} > #{dumpfile} && \
        pg_restore --verbose --clean --no-acl --no-owner -h #{host} -U #{user} -d #{database} #{dumpfile}; \
        if [ $? -gt 1 ]; then false; else true; fi
        CMD

        run commands do |ch, stream, data|
          if data =~ /Password/
            ch.send_data("#{pass}\n")
          end
        end
      end
      before 'postgresql:remote:heroku:restore', 'deploy:stop'
      after 'postgresql:remote:heroku:restore', 'deploy:start'

      desc 'Sync remote server db from Heroku db'
      task :sync do
        dump
        upload
        restore
      end
    end
  end
end
