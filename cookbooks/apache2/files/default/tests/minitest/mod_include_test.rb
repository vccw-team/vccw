require File.expand_path('../support/helpers', __FILE__)

describe 'apache2::mod_include' do
  include Helpers::Apache

  it 'enables include_module' do
    apache_enabled_modules.must_include "include_module"
  end

  it 'drops off the include module configuration' do
    assert_match(/AddType text\/html .shtml/, File.read("#{node['apache']['dir']}/mods-enabled/include.conf"))
    assert_match(/AddOutputFilter INCLUDES .shtml/, File.read("#{node['apache']['dir']}/mods-enabled/include.conf"))
  end

end
