# config valid only for current version of Capistrano
lock "3.8.1"

set :user, 'dotthei'
set :application, "artaround"
set :repo_url, "git@github.com:artaround/artaround-web.git"
set :domain, 'theartaround.us'
set :branch, 'master'

set :use_sudo, false

set :deploy_via, :remote_cache
set :runner, 'dotthei'
set :admin_runner, 'dotthei'

set :tmp_dir, '/home/dotthei/tmp'

role :app, fetch(:domain)
role :web, fetch(:domain)


# after 'deploy', 'deploy:cleanup'
after 'deploy:updated', 'deploy:shared_links'
after 'deploy:updated', 'deploy:bundle_install'
after 'deploy:updated', 'deploy:create_mongo_indexes'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
