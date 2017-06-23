namespace :deploy do
  task :start do; end
  task :stop do; end
  task :migrate do; end

  desc 'Restart the server'
  task :restart do
    on roles(:app) do
      execute "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
    end
  end

  desc 'Create mongo indexes'
  task :create_mongo_indexes do
    on roles(:app) do
      # run "cd #{release_path} && bundle exec rake db:mongoid:create_indexes"
      gem_home = "export GEM_HOME=#{fetch(:gems_dir)}"
      ruby_lib = "export RUBYLIB=#{fetch(:app_directory)}/lib"
      bin_path = "export PATH=#{fetch(:app_directory)}/bin:$PATH"

      execute "#{gem_home} && #{ruby_lib} && #{bin_path} && cd #{release_path} && bundle exec rake db:mongoid:create_indexes"
    end
  end

  desc 'Install dependencies'
  task :bundle_install do
    on roles(:app) do
      gem_home = "export GEM_HOME=#{fetch(:gems_dir)}"
      ruby_lib = "export RUBYLIB=#{fetch(:app_directory)}/lib"
      bin_path = "export PATH=#{fetch(:app_directory)}/bin:$PATH"

      execute "#{gem_home} && #{ruby_lib} && #{bin_path} && cd #{release_path} && bundle install --local --path #{fetch(:gems_dir)}"
    end
  end

  desc 'Get shared files into position'
  task :shared_links do
    on roles(:web, :app) do
      execute "ln -nfs #{shared_path}/config/admin.yml #{release_path}/config/admin.yml"
      execute "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
      execute "ln -nfs #{shared_path}/config/pony.yml #{release_path}/config/pony.yml"
      execute "ln -nfs #{shared_path}/config/email.yml #{release_path}/config/email.yml"
      execute "ln -nfs #{shared_path}/system #{release_path}/public/system"
      # execute "rm #{File.join release_path, 'log'}"
      execute "ln -nfs #{shared_path}/log #{release_path}/log"
    end
  end
end
