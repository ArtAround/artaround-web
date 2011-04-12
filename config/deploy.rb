require 'bundler/capistrano'

set :application, "artaround"

set :scm, :git
set :repository, "git@github.com:ArtAround/artaround-web.git"

set :deploy_to, "/home/dotthei/apps/#{application}"
set :deploy_via, :copy
set :copy_strategy, :export

set :user, "dotthei"
set :use_sudo, false

desc "Setup the staging server"
task :staging do
  set :app_server,  "staging.theartaround.us"
  set :db_server,   "staging.theartaround.us"
  set :web_server,  "staging.theartaround.us"

  finalize_init
end

task :finalize_init do
  role :app,  app_server
  role :db,   db_server
  role :web,  web_server
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
