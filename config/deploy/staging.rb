set :deploy_to, deploysecret(:deploy_to)
set :server_name, deploysecret(:server_name)
set :db_server, deploysecret(:db_server)
set :branch, :desarrollo_demo
set :ssh_options, port: deploysecret(:ssh_port)
set :stage, :staging
set :rails_env, :staging

server deploysecret(:server1), user: deploysecret(:user), roles: %w(web app db importer cron)
