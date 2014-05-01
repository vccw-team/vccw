#
# Cookbook Name:: rbenv
# Provider:: execute
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#

include Chef::Mixin::Rbenv

def load_current_resource
  @path                         = [ rbenv_shims_path, rbenv_bin_path ] + new_resource.path + system_path
  @environment                  = new_resource.environment
  @environment["PATH"]          = @path.join(":")
  @environment["RBENV_ROOT"]    = rbenv_root_path
  @environment["RBENV_VERSION"] = new_resource.ruby_version if new_resource.ruby_version

  new_resource.environment(@environment)
end

action :run do
  execute "eval \"$(rbenv init -)\"" do
    environment new_resource.environment
  end

  execute new_resource.name do
    command     new_resource.command
    creates     new_resource.creates
    cwd         new_resource.cwd
    environment new_resource.environment
    group       new_resource.group
    returns     new_resource.returns
    timeout     new_resource.timeout
    user        new_resource.user
    umask       new_resource.umask
  end

  new_resource.updated_by_last_action(true)
end

private

  def system_path
    shell_out!("echo $PATH").stdout.chomp.split(':')
  end
