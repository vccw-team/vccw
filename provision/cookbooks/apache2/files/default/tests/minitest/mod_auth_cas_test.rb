require File.expand_path('../support/helpers', __FILE__)

describe "apache2::mod_auth_cas" do
  include Helpers::Apache

  it 'enables auth_cas_module' do
    skip if %w{rhel fedora}.include?(node['platform_family']) && node['platform_version'].to_f > 6.0
    apache_enabled_modules.must_include "auth_cas_module"
  end

end
