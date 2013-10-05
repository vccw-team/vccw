require File.expand_path('../support/helpers', __FILE__)

describe 'apache2::mod_cgi' do
  include Helpers::Apache

  # the cgi module can be either cgi or cgid
  it 'enables cgi or cgid_module' do
    assert(apache_enabled_modules.include?('cgi_module') ||
      apache_enabled_modules.include?('cgid_module')
    )
  end

end
