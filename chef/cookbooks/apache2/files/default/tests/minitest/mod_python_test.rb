require File.expand_path('../support/helpers', __FILE__)

describe 'apache2::mod_python' do
  include Helpers::Apache

  it 'enables python_module' do
    apache_enabled_modules.must_include "python_module"
  end

end
