require 'serverspec'
require 'net/ssh'
require 'tempfile'
require 'yaml'

$conf = YAML.load(
  File.open(
    'provision/default.yml',
    File::RDONLY
  ).read
)

if File.exists?(File.join(ENV["HOME"], '.vccw/config.yml'))
  _custom = YAML.load(
    File.open(
      File.join(ENV["HOME"], '.vccw/config.yml'),
      File::RDONLY
    ).read
  )
  $conf.merge!(_custom) if _custom.is_a?(Hash)
end

if File.exists?('site.yml')
  _site = YAML.load(
    File.open(
      'site.yml',
      File::RDONLY
    ).read
  )
  $conf.merge!(_site) if _site.is_a?(Hash)
end

set :backend, :ssh

host = $conf['hostname']

config = Tempfile.new('', Dir.tmpdir)
`unset RUBYLIB; vagrant ssh-config #{host} > #{config.path}`

options = Net::SSH::Config.for(host, [config.path])
puts options.to_s
set :host,        host
set :ssh_options, options
