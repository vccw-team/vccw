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

set :backend, :docker
set :docker_url, 'unix:///var/run/docker.sock'
set :docker_container, $conf["hostname"]

# TODO https://github.com/swipely/docker-api/issues/202
Excon.defaults[:ssl_verify_peer] = false
