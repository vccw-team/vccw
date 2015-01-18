require File.expand_path('../support/helpers', __FILE__)

describe 'apache2::mod_perl' do
  include Helpers::Apache

  it 'enables perl_module' do
    apache_enabled_modules.must_include "perl_module"
  end

  it 'installs the apache request library' do
    req_pkg = case node['platform']
              when 'debian', 'ubuntu' then 'libapache2-request-perl'
              else 'perl-libapreq2'
              end
    package(req_pkg).must_be_installed
  end

end
