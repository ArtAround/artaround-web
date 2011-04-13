# Bundler comes with a Capistrano task that will grab the locked
# gems specified in Gemfile.lock and put them in shared/bundle,
# skipping the gems defined in the development and test groups.
#
# More information available at:
#
#   https://github.com/carlhuda/bundler/blob/master/lib/bundler/deployment.rb
# 
# Warning: this requires bundler to be installed. On the standard
# WebFaction setup, you should have bundler 1.0.10, which should
# be good enough.
require 'bundler/capistrano'

# Since we're hosting with WebFaction, this is the name of the
# application defined in the WebFaction Control Panel. You can
# see a list of applications at:
#
#   https://panel.webfaction.com/app_/list
#
# With WebFaction, we define an application, but this is
# actually a folder containing an nginx configuration folder,
# a gem folder and the actual application folder, which
# WebFaction calls "a site".
#
# The convention we'll use is that we define an application,
# e.g. "artaround", and have a site for staging and a site
# for production. 
set :application, "artaround"

# Deploy from the Github repo, using the read-only URL.
set :scm, :git
set :repository, "git://github.com/ArtAround/artaround-web.git"
set :branch, "master" # Optionally, specify the branch.

# Do a git clone locally, create a gzipped tarball and upload
# it to the server.
#
# This means there's no need for having git or any other SCM to
# be present on the server, so less hassle. 
set :deploy_via, :copy 
set :copy_strategy, :export

# SSH-related settings.
set :user, "dotthei"
ssh_options[:forward_agent] = true
set :use_sudo, false

# This is a task for setting up the staging server details,
# like the app server address or database server address.
# Also, other staging server-related stuff should go in here.
#
# This allows us to deploy using:
#
#   cap staging deploy
# 
# which is a good thing, because it keeps the deploy script
# DRY.
desc "Setup the staging server"
task :staging do
  set :deploy_to, "/home/dotthei/webapps/#{application}/staging"

  # We don't really need this, but it's a good example of
  # how to set the server details in case the staging
  # server and the production server are not the same
  set :app_server,  "theartaround.us"
  set :db_server,   "theartaround.us"
  set :web_server,  "theartaround.us"

  # Run the finalize_init task, that will set the actual
  # server roles using the Capistrano "role" command and,
  # eventually, do other initialization tasks that are
  # common to all environments.
  finalize_init
end

desc "Setup the production server"
task :production do
  set :deploy_to, "/home/xhr/webapps/#{application}/production"

  # We don't really need this, but it's a good example of
  # how to set the server details in case the staging
  # server and the production server are not the same
  set :app_server,  "theartaround.us"
  set :db_server,   "theartaround.us"
  set :web_server,  "theartaround.us"

  finalize_init
end

# This task should run as the last command in the staging,
# production or whatever environment we have. It should
# contain only actions common to all environments.
task :finalize_init do
  # If there is more than one app_server (i.e. for load
  # balancing), use:
  #
  #   role :app, *app_server
  #
  # Same thing goes for multiple db servers or multiple
  # web servers.
  role :app,  app_server
  role :db,   db_server
  role :web,  web_server
end

after "deploy:symlink", "deploy:finishing_touches"

namespace :deploy do
  # Passenger does not have a start/stop command, but will restart if we
  # touch a restart.txt file in the app's tmp folder.
  task :start do ; end

  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  # Copy the configuration files required from the shared/config/ folder to
  # current/config/.
  task :finishing_touches, :roles => [:db] do
    run "cp -pf #{shared_path}/config/admin.yml #{current_path}/config/admin.yml"
    run "cp -pf #{shared_path}/config/flickr.yml #{current_path}/config/flickr.yml"
    run "cp -pf #{shared_path}/config/mongoid.yml #{current_path}/config/mongoid.yml"
    run "cp -pf #{shared_path}/config/pony.yml #{current_path}/config/pony.yml"
  end
end
