# set 'target=production' in the command line to trigger production deploy
set :environment, (ENV['target'] || 'staging')

set :user, 'dotthei'
set :application, 'artaround'

set :deploy_to, "/home/#{user}/webapps/artaround_#{environment}/artaround"

# both production and staging environments are on the same box
set :domain, 'theartaround.us'

set :scm, :git
set :repository, "git@github.com:ArtAround/artaround-web.git"
set :branch, 'master'

set :use_sudo, false

set :deploy_via, :remote_cache
set :runner, user
set :admin_runner, runner

role :app, domain
role :web, domain


after "deploy", "deploy:cleanup"
after "deploy:update_code", "deploy:shared_links"
after "deploy:update_code", "deploy:bundle_install"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :migrate do; end
  
  desc "Restart the server"
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  # Todo later, a good idea:
#   desc "Create indexes"
#   task :create_indexes, :roles => :app, :except => {:no_release => true} do
#     run "cd #{release_path} && rake create_indexes"
#   end
  
  task :bundle_install, :roles => :app, :except => {:no_release => true} do
    run "cd #{release_path} && bundle install --local"
  end
  
  desc "Get shared files into position"
  task :shared_links, :roles => [:web, :app] do
    run "ln -nfs #{shared_path}/config/admin.yml #{release_path}/config/admin.yml"
    run "ln -nfs #{shared_path}/config/flickr.yml #{release_path}/config/flickr.yml"
    run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
    run "ln -nfs #{shared_path}/config/pony.yml #{release_path}/config/pony.yml"
    run "ln -nfs #{shared_path}/config/email.yml #{release_path}/config/email.yml"
    run "rm #{File.join release_path, 'log'}"
    run "ln -nfs #{shared_path}/log #{release_path}/log"
  end
end