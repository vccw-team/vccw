require File.expand_path('../support/helpers', __FILE__)

describe "apache2::mod_fastcgi" do
  include Helpers::Apache

  it 'enables fastcgi_module' do
    skip if %w{rhel fedora}.include?(node['platform_family'])
    apache_enabled_modules.must_include "fastcgi_module"
  end

end
