require 'bundler/capistrano'

set :application, "artaround"

set :scm, :git
set :repository, "git@github.com:ArtAround/artaround-web.git"

set :deploy_to, "/home/dotthei/apps/#{application}"
set :deploy_via, :remote_cache

set :user, "dotthei"
ssh_options[:forward_agent] = true
set :use_sudo, false

desc "Setup the staging server"
task :staging do
  set :app_server,  "staging.theartaround.us"
  set :db_server,   "staging.theartaround.us"
  set :web_server,  "staging.theartaround.us"


  finalize_init
end

desc "Setup the production server"
task :production do
  set :app_server,  "theartaround.us"
  set :db_server,   "theartaround.us"
  set :web_server,  "theartaround.us"

  finalize_init
end

task :finalize_init do
  role :app,  app_server
  role :db,   db_server
  role :web,  web_server
end

after "deploy:symlink", "deploy:finishing_touches"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end

  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :finishing_touches, :roles => [:db] do
    run "cp -pf #{shared_path}/config/admin.yml #{current_path}/config/admin.yml"
    run "cp -pf #{shared_path}/config/flickr.yml #{current_path}/config/flickr.yml"
    run "cp -pf #{shared_path}/config/mongoid.yml #{current_path}/config/mongoid.yml"
    run "cp -pf #{shared_path}/config/pony.yml #{current_path}/config/pony.yml"
  end
end
