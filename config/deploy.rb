# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'WonkoWeb'
set :scm, :git
set :repo_url, 'https://github.com/02JanDal/WonkoWeb.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/apps/WonkoWeb'
set :deploy_user, :deployer

# For automated deployment from travis
set :ssh_options, keys: ['deploy_id_rsa'] if File.exist?('deploy_id_rsa')

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs,
    fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
set :default_env, path: '/opt/ruby/bin:$PATH'

# Default value for keep_releases is 5
set :keep_releases, 5

set :config_files, %w(nginx.conf log_rotation monit unicorn.rb unicorn_init.sh)
set :executable_config_files, %w(unicorn_init.sh)

set :bundle_without, 'development'
set :bundle_jobs, 2
set :bundle_flags, '--deployment'

set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.2.0'

set :pg_database, fetch(:pg_database).downcase
set :pg_user, fetch(:pg_database).downcase

set :templates_path, 'config/deploy/templates'

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc. The full_app_name variable isn't
# available at this point so we use a custom template {{}}
# tag and then add it at run time.
set :symlinks, [
  {
    source: 'nginx.conf',
    link: '/etc/nginx/sites-enabled/{{full_app_name}}'
  },
  {
    source: 'unicorn_init.sh',
    link: '/etc/init.d/unicorn_{{full_app_name}}'
  },
  {
    source: 'log_rotation',
    link: '/etc/logrotate.d/{{full_app_name}}'
  },
  {
    source: 'monit',
    link: '/etc/monit/conf.d/{{full_app_name}}.conf'
  }
]

namespace :deploy do
  before :deploy, 'deploy:check_revision'
  before :deploy, 'deploy:run_tests' unless ENV['TRAVIS_BRANCH']
  after :finishing, 'deploy:cleanup'

  after 'deploy:updated', 'deploy:setup_config'
  before 'deploy:setup_config', 'nginx:remove_default_vhost'
  after 'deploy:setup_config', 'nginx:reload'
  after 'deploy:setup_config', 'monit:restart'
  after 'deploy:publishing', 'deploy:restart'
end
