require 'serverspec'
require 'docker'
require 'json'

$conf = YAML.load(
  File.open(
    'provision/default.yml',
    File::RDONLY
  ).read
)

if File.exists?( 'site.yml' )
  site = YAML.load(
    File.open(
      'site.yml',
      File::RDONLY
    ).read
  )
  $conf.merge!( site ) if site.is_a?( Hash )
end

if ENV['VCCW_ENV'].instance_of?( String )
  site = JSON.parse( ENV['VCCW_ENV'] );
  $conf.merge!( site ) if site.is_a?( Hash );
end

$conf["user"] = "ubuntu"
$conf["vagrant_dir"] = "/vagrant"

# set :backend, :ssh

# host = $conf['hostname']

# config = Tempfile.new('', Dir.tmpdir)
# `unset RUBYLIB; vagrant ssh-config #{host} > #{config.path}`

# options = Net::SSH::Config.for(host, [config.path])
# puts options.to_s
# set :host,        host
# set :ssh_options, options

set :backend, :docker
set :docker_url, 'unix:///var/run/docker.sock'
set :docker_container, 'vccw-test'

# TODO https://github.com/swipely/docker-api/issues/202
Excon.defaults[:ssl_verify_peer] = false
