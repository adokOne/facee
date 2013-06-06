require "rvm/capistrano"
require "bundler/capistrano"
require "capistrano"
set :application, "facee"
set :repository,  "git://github.com/adokOne/facee.git"
set :user, "root"
set :use_sudo, false

set :deploy_via, :remote_cache
set :scm, :git
set :branch, 'master'
set :scm_verbose, true
set :deploy_to, "/var/www/#{application}"

set :rails_env, :production
set :rvm_ruby_string , "1.9.3"
set :rvm_type, :system
set :rvm_path, "/usr/local/rvm"
ssh_options[:forward_agent] = true;

server "88.198.110.171", :app, :web, :db, :primary => true


#after 'deploy:finalize_update', 'deploy:symlink_db'

namespace :deploy do
  desc "Symlinks the database.yml"
 # task :symlink_db, :roles => :app do
    #run "ln -s #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
   # run "ln -s #{shared_path}/log/production.log #{latest_release}/log/production.log"
 # end
end

desc "Create socket file symlink for nginx"
task :symlink_sockets, :except => {:no_release => true} do
  run "mkdir -p #{shared_path}/sockets"
  run "ln -s #{shared_path}/sockets #{release_path}/tmp/sockets"
end
shared_children.push "tmp/sockets"


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

require 'capistrano-unicorn'
