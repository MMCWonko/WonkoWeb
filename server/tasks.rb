require_relative 'docker'

if File.exist? 'server/secrets.yml'
  data = YAML.load(File.open('server/secrets.yml')).with_indifferent_access
  storage = if File.exist?('server/storage.json')
              JSON.parse(File.read('server/storage.json'), symbolize_names: true)
            else
              {}
            end

  fail 'You need to create server/secrets.yml and fill it with data!' unless data

  Docker.define :wonkoweb_mongodb do
    image 'dockerfile/mongodb'
    port 27_017
    volume ENV['MONGODB_DATA_DIR'] || '/srv/wonkoweb/mongodb/', '/data/db'
  end
  Docker.define :wonkoweb_mariadb do
    image 'mariadb'
    port 3306
    volume ENV['MARIADB_DATA_DIR'] || '/srv/wonkoweb/mariadb', '/var/lib/mysql'
    env MYSQL_ROOT_PASSWORD: data[:piwik][:db][:pass]
  end
  Docker.define :wonkoweb_piwik do
    build '.', 'server/Dockerfile.piwik'
    port 5002 => 80
    link :wonkoweb_mariadb, :db_1
    env DB_USER: data[:piwik][:db][:user], DB_PASSWORD: data[:piwik][:db][:pass], DB_NAME: 'wonkoweb_piwik',
        PIWIK_USER: data[:piwik][:user], PIWIK_PASSWORD: data[:piwik][:pass],
        PIWIK_SEED_DATABASE: (storage[:piwik_seeded] ? 0 : 1)
  end
  Docker.define :wonkoweb_errbit do
    build '.', 'server/Dockerfile.errbit'
    link :wonkoweb_mongodb, :mongodb
    port 5001 => 4000
  end
  Docker.define :wonkoweb do
    build '.', 'server/Dockerfile'
    link :wonkoweb_mongodb, :mongodb
    link :wonkoweb_errbit, :errbit
    link :wonkoweb_piwik, :piwik
    port 5000 => 5000
    env SECRET_KEY_BASE: data[:wonkoweb][:secret_key_base],
        WONKOWEB_PIWIK_HOST: 'piwik.' + data[:host], WONKOWEB_PIWIK_PORT: 80
  end
  Docker.define :nginx do
    build 'server/', 'server/Dockerfile.nginx'
    port 80 => 80
    env TOP_LEVEL_HOST: data[:host]
    link :wonkoweb, :wonkoweb
    link :wonkoweb_piwik, :piwik
    link :wonkoweb_errbit, :errbit
  end

  namespace :docker do
    namespace :build do
      desc 'Builds the docker image for WonkoWeb'
      task wonkoweb: ['assets:precompile', 'assets:clean'] do
        Docker.get(:wonkoweb).create
      end

      desc 'Builds the docker image for errbit'
      task :errbit do
        Docker.get(:wonkoweb_errbit).create
      end

      desc 'Builds the docker image for piwik'
      task :piwik do
        Docker.get(:wonkoweb_piwik).create
      end

      desc 'Builds the docker image for nginx'
      task :nginx do
        Docker.get(:nginx).create
      end
    end

    desc 'Builds all docker images'
    task build: %w(docker:build:wonkoweb docker:build:errbit docker:build:piwik)

    namespace :run do
      desc 'Runs the docker image for WonkoWeb'
      task :wonkoweb do
        Docker.get(:wonkoweb).run
      end

      desc 'Runs the docker image for MongoDB'
      task :mongodb do
        Docker.get(:wonkoweb_mongodb).run
      end

      desc 'Runs the docker image for errbit'
      task :errbit do
        Docker.get(:wonkoweb_errbit).run
      end

      desc 'Runs the docker image for MariaDB'
      task :mariadb do
        Docker.get(:wonkoweb_mariadb).run
      end

      desc 'Runs the docker image for Piwik'
      task :piwik do
        Docker.get(:wonkoweb_piwik).run
        storage[:piwik_seeded] = true
        File.write 'server/storage.json', JSON.generate(storage)
      end

      desc 'Runs the docker image for NGINX'
      task :nginx do
        Docker.get(:nginx).run
      end
    end

    desc 'Runs all docker images'
    task :run do
      Rake::Task['docker:run:mongodb'].invoke
      Rake::Task['docker:run:mariadb'].invoke
      sleep 15
      Rake::Task['docker:run:errbit'].invoke
      Rake::Task['docker:run:piwik'].invoke
      sleep 2
      Rake::Task['docker:run:wonkoweb'].invoke

      Rake::Task['docker:run:nginx'].invoke
    end

    desc 'Stops all containers'
    task :stop do
      Docker.stop_all
    end

    desc 'Removes all containers'
    task rm: %w(docker:stop) do
      Docker.rm_all
    end

    desc 'Sets up a WonkoWeb server'
    task up: %w(docker:build docker:run)
  end
end
