require 'spec_helper'

describe 'PHP config parameters' do
  context php_config('default_charset', :ini => '/etc/php/7.0/apache2/php.ini') do
    its(:value) { should eq 'UTF-8' }
  end

  context  php_config('mbstring.language', :ini => '/etc/php/7.0/apache2/php.ini') do
    its(:value) { should eq 'neutral' }
  end

  context  php_config('mbstring.internal_encoding', :ini => '/etc/php/7.0/apache2/php.ini') do
    its(:value) { should eq 'UTF-8' }
  end

  context php_config('date.timezone', :ini => '/etc/php/7.0/apache2/php.ini') do
    its(:value) { should eq 'UTC' }
  end

  context php_config('short_open_tag', :ini => '/etc/php/7.0/apache2/php.ini') do
    its(:value) { should_not eq 1 }
    its(:value) { should_not eq 'On' }
  end

  context php_config('session.save_path', :ini => '/etc/php/7.0/apache2/php.ini') do
    its(:value) { should eq '/tmp' }
  end
end
