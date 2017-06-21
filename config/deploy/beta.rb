server fetch(:domain), user: fetch(:user), roles: %w{web app}
set :gems_dir, "/home/#{fetch(:user)}/webapps/beta/gems"
set :deploy_to, "/home/#{fetch(:user)}/webapps/beta/artaround"
set :app_directory, "/home/#{fetch(:user)}/webapps/beta"
