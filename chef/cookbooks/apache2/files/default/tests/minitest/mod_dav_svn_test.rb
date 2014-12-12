require File.expand_path('../support/helpers', __FILE__)

describe 'apache2::mod_dav_svn' do
  include Helpers::Apache

  it 'enables dav_svn_module' do
    apache_enabled_modules.must_include "dav_svn_module"
  end

  it 'enables dav_module' do
    apache_enabled_modules.must_include "dav_module"
  end

end
