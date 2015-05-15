def get_container_info(container)
  JSON.parse capture(:docker, :inspect, container)
rescue SSHKit::Runner::ExecuteError, SSHKit::Command::Failed
  []
end

def running?(container)
  info = get_container_info container
  info.size > 0 && info.first['State']['Running']
end

def ensure_stopped(container)
  execute :docker, :stop, container if running? container
end

def remove_stale(container)
  info = get_container_info container
  execute :docker, :rm, container if info.size > 0 && !info.first['State']['Running']
end

def get_or_update_git_repo(base_path, repo_name, repo_url)
  if test("[ -d #{base_path}/#{repo_name} ]")
    within repo_name do
      execute :git, :fetch
      execute :git, :reset, '--hard', 'origin/master'
    end
  else
    execute :git, :clone, '--depth', '1', repo_url
  end
end

def add_to_dockerfile(base_path, repo_name, line)
  execute "echo \"#{line}\" >> #{base_path}/#{repo_name}/Dockerfile"
end

def build_dockerfile(tag = nil)
  if tag.nil?
    execute :docker, :build, '.'
  else
    execute :docker, :build, "-t=#{tag}", '.'
  end
end

def deploy_nginx_conf(name)
  on roles :web, primary: true do
    smart_template "nginx_#{name}.conf"
    sudo "/bin/ln -nfs #{shared_path}/config/nginx_#{name}.conf /etc/nginx/sites-enabled/#{name}"
  end
  invoke 'nginx:reload'
end
