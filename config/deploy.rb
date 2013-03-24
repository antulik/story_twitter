require "bundler/capistrano"


set :application, "story_twitter"

set :user, "deployer"
set :deploy_to, "/var/www/apps/story_twitter"
set :use_sudo, false
set :keep_releases, 3

set :repository, 'git@github.com:antulik/story_twitter.git'
set :scm, :git
set :deploy_via, :remote_cache

default_run_options[:pty]   = true
ssh_options[:forward_agent] = true

server "server.antonkatunin.com", :web, :app, :db, primary: true


set :rvm_ruby_string, '1.9.3-p392@story_twitter'
set :rvm_type, :user
require "rvm/capistrano"


before 'deploy:setup', 'rvm:create_gemset'

after "deploy:update_code", "deploy:migrate"
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  %w[start stop].each do |command|
    desc "#{command} nginx server"
    task command, roles: :app, except: {no_release: true} do
      sudo "#{try_sudo} service nginx #{command}"
    end
  end

  desc "restart passenger server"
  task :restart, roles: :app, except: {no_release: true} do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  task :setup_config, roles: :app do
#sudo "ln -nfs #{current_path}/config/nginx.conf /opt/nginx/conf/nginx.conf"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml"), "#{shared_path}/config/database.yml"
    run "mkdir -p #{shared_path}/uploads"
    puts "==> IMPORTANT!!! Now edit database.yml in #{shared_path}/config <==="
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "rm -rf #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/"
  end
  after "deploy:finalize_update", "deploy:symlink_config"
end
