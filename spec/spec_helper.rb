require 'serverspec'
require 'net/ssh'
require 'tempfile'

set :backend, :ssh

host = "vccw.test"

$conf = YAML.load(
  File.open(
    File.join(File.dirname(File.dirname(__FILE__)), 'provision/default.yml'),
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

if File.exists?(File.join(File.dirname(File.dirname(__FILE__)), 'site.yml'))
  _site = YAML.load(
    File.open(
      File.join(File.dirname(File.dirname(__FILE__)), 'site.yml'),
      File::RDONLY
    ).read
  )
  $conf.merge!(_site) if _site.is_a?(Hash)
end

# forcing config variables
$conf["vagrant_dir"] = "/vagrant"
$conf["user"] = "vagrant"

config = Tempfile.new('', Dir.tmpdir)
`unset RUBYLIB; vagrant ssh-config #{host} > #{config.path}`

options = Net::SSH::Config.for(host, [config.path])
puts options.to_s
set :host,        host
set :ssh_options, options
