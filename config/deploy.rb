require 'hoptoad_notifier/capistrano'

default_run_options[:pty] = true

set :application, "originalprojects"
set :user, 'www-data'
set :use_sudo, false

role :web, "174.143.150.91"                          # Your HTTP server, Apache/etc
role :app, "174.143.150.91"                          # This may be the same as your `Web` server
role :db,  "174.143.150.91", :primary => true        # This is where Rails migrations will run

set :deploy_to, lambda { "/var/www/#{application}" }

set :scm, :git
set :repository, "git@viget.unfuddle.com:viget/op.git"
set :branch, "origin/master"
set :migrate_target, :current

set :group_writable, false

set(:latest_release) { fetch(:current_path) }
set(:release_path) { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision) { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision) { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

after "deploy:update_code", "search:symlink"
# after "deploy:update_code", "search:restart"

namespace :deploy do
  task :default do
    update
    restart
  end

  desc "Setup a GitHub-style deployment."
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
    run "git clone #{repository} #{current_path}"
  end

  task :update do
    transaction do
      update_code
    end
  end

  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    finalize_update
    bundle_gems
    generate_database_yml
    compress_css_js
  end

  desc "Update the database (overwritten to avoid symlink)"
  task :migrations do
    update_code
    migrate
    restart
  end

  desc "Create the database.yml file"
  task :generate_database_yml do
    run "cd #{current_path}; cp config/database.yml-sample config/database.yml"
  end

  desc "Deploy all the bundled gems"
  task :bundle_gems do
    run "cd #{current_path}; gem bundle --only production"
  end

  desc "Compress JavaScript & CSS on the server"
  task :compress_css_js do
    rake "asset:packager:build_all"
  end

  desc "Remigrate & reseed DB"
  task :refresh_db do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")
    rake_cmd = "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env}"
    update_code
    rake "db:drop", "db:create", "db:migrate"
    rake "db:seed"
    restart
  end

  desc "Regenerate images and avatars"
  task :regen_images do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")
    rake_cmd = "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env}"
    rake "regen:avatars", "regen:images"
  end

  namespace :rollback do
    desc "Moves the repo back to the previous version of HEAD"
    task :repo, :except => { :no_release => true } do
      set :branch, "HEAD@{1}"
      deploy.default
    end

    desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
    task :cleanup, :except => { :no_release => true } do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end

    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end

  task :start do; end
  task :stop do; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :search do
  desc "create symlink for search index"
  task :symlink do
    rails_env = fetch(:rails_env, "production")
    run "mkdir -p #{shared_path}/sphinx/#{rails_env}"
    run "ln -nfs #{shared_path}/sphinx #{release_path}/db/sphinx"
  end

  desc 'Restart the Sphinx server'
  task :restart, :roles => :app do
    rake "ts:config", "ts:stop"
    rake "ts:index", "ts:start"
  end
end

desc "tail production log files"

task :tail_logs, :roles => :app do
  run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

def rake(*cmd)
  rake = fetch(:rake, "rake")
  rails_env = fetch(:rails_env, "production")
  run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} #{cmd.join(' ')}"
end
