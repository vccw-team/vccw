require File.expand_path('../support/helpers', __FILE__)

describe 'apache2::mod_ssl' do
  include Helpers::Apache

  it 'installs the mod_ssl package on RHEL distributions' do
    skip unless ["rhel", "fedora"].include? node['platform_family']
    package("mod_ssl").must_be_installed
  end

  it 'enables ssl_module' do
    apache_enabled_modules.must_include "ssl_module"
  end

  it 'does not store SSL config in conf.d' do
    file("#{node['apache']['dir']}/conf.d/ssl.conf").wont_exist
  end

  it "is configured to listen on port 443" do
    apache_configured_ports.must_include(443)
  end

  it 'configures SSLCiphersuit from an attribute' do
    assert_match(/^SSLCipherSuite #{node['apache']['mod_ssl']['cipher_suite']}$/,
      File.read("#{node['apache']['dir']}/mods-enabled/ssl.conf"))
  end

end
