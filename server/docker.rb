class Docker
  attr_reader :name

  class << self; attr_accessor :registry end
  @registry = {}

  def initialize(name, &block)
    @name = name
    @ports = []
    @links = {}
    @volumes = []
    @env = {}
    instance_eval(&block)

    Docker.registry[name] = self
  end

  ######################## BUILD ########################
  def build(dir, dockerfile = nil)
    @build = dir
    @dockerfile = dockerfile
    @image = nil
  end

  def image(tag, version = nil)
    @image = tag + (version.nil? ? '' : ':' + version)
    @build = nil
  end

  def port(container_port)
    if container_port.is_a? Hash
      host = container_port.keys.first
      @ports << "#{host}:#{container_port[host]}"
    else
      @ports << container_port.to_s
    end
  end

  def link(container, aka = nil)
    aka ||= container
    @links[aka] = (Docker.registry[container] || container)
  end

  def volume(host, container)
    FileUtils.mkdir_p host unless Dir.exist?(host) || File.exist?(host)
    @volumes << "#{host}:#{container}"
  end

  def env(variables = {})
    @env = @env.merge variables
  end

  def cmd(cmd)
    @cmd = cmd
  end

  ######################### RUN #########################
  def create
    if @build
      system "docker build -t #{@name} -f #{@dockerfile || (@build + '/Dockerfile')} #{@build}"
    elsif @image
      system "docker pull #{@image}"
    end
  end

  def run
    options = ['-d']
    @ports.each { |p| options << '-p ' + p }
    @links.each { |aka, container| options << '--link ' + "#{container.name}:#{aka}" }
    @volumes.each { |v| options << '-v ' + v }
    @env.each { |key, value| options << "-e #{key}=\"#{value}\"" }
    puts 'Running ' + @name.to_s
    cmd = "docker run #{options.join ' '} --name=#{@name} #{image_name} #{@cmd.nil? ? '' : @cmd}"
    puts '  ' + cmd
    system cmd
  end

  def stop
    system "docker stop #{@name}"
  end

  def rm
    system "docker rm #{@name}"
  end

  ################ ACCESSORS AND EXTRA ################
  def image_name
    if @image
      @image
    elsif @build
      @name
    else
      fail 'No existing image nor build specified'
    end
  end

  def self.define(name, &block)
    new(name, &block)
  end

  def self.get(name)
    Docker.registry[name]
  end

  def self.stop_all
    system "docker stop #{Docker.registry.keys.map(&:to_s).join ' '}"
  end

  def self.rm_all
    system "docker rm #{Docker.registry.keys.map(&:to_s).join ' '}"
  end
end
