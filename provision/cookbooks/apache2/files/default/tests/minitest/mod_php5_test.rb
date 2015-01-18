require File.expand_path('../support/helpers', __FILE__)

describe 'apache2::mod_php5' do
  include Helpers::Apache

  it 'enables php5_module' do
    apache_enabled_modules.must_include "php5_module"
  end

  it "deletes the packaged php config if any" do
    file("#{node['apache']['dir']}/conf.d/php.conf").wont_exist
  end
end
