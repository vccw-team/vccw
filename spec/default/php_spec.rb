require 'spec_helper'

describe 'PHP config parameters' do
  $conf['php_ini'].each do |ini_key, ini_value|
    context php_config(ini_key, :ini => '/etc/php/7.0/apache2/conf.d/99-vccw.ini') do
      if true == ini_value
        its(:value) { should eq 1 }
      elsif false == ini_value
        its(:value) { should eq "" }
      else
        its(:value) { should eq ini_value }
      end
    end
  end
end
