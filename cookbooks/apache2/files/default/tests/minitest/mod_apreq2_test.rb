require File.expand_path('../support/helpers', __FILE__)

describe 'apache2::mod_apreq2' do
  include Helpers::Apache

  it 'enables apreq_module' do
    apache_enabled_modules.must_include "apreq_module"
  end

  it 'symlinks the module on EL' do
    skip unless %w{rhel fedora}.include?(node['platform_family'])
    libdir = node['kernel']['machine'] == 'x86_64' ? "lib64" : "lib"
    link(
      "/usr/#{libdir}/httpd/modules/mod_apreq.so"
    ).must_exist.with(
        :link_type, :symbolic).and(:to, "/usr/#{libdir}/httpd/modules/mod_apreq2.so"
        )
  end
end
