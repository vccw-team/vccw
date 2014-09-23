# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'spec_helper'

include SpecInfra::Helper::Ssh
include SpecInfra::Helper::DetectOS

describe package('httpd') do
  it { should be_installed }
end

describe service('httpd') do
    it { should be_enabled }
end

describe service('httpd') do
    it { should be_running }
end

describe port(80) do
    it { should be_listening }
end

describe 'PHP config parameters' do
  context  php_config('default_charset') do
    its(:value) { should eq 'UTF-8' }
  end

  context  php_config('mbstring.language') do
    its(:value) { should eq 'neutral' }
  end

  context  php_config('mbstring.internal_encoding') do
    its(:value) { should eq 'UTF-8' }
  end

  context php_config('date.timezone') do
    its(:value) { should eq 'UTC' }
  end

  context php_config('short_open_tag') do
    its(:value) { should eq 'Off' }
  end

  context php_config('session.save_path') do
    its(:value) { should eq '/tmp' }
  end

end

describe command('/usr/local/bin/wp --version') do
  it { should return_exit_status 0 }
end

describe command("wget -q http://localhost/ -O - | head -100 | grep generator") do
    it { should return_stdout /<meta name="generator" content="WordPress .*"/i }
end

describe command("wget --no-check-certificate -q https://localhost/ -O - | head -100 | grep generator") do
    it { should return_stdout /<meta name="generator" content="WordPress .*"/i }
end

describe file('/var/www/wordpress/wp-content/plugins/theme-check/readme.txt') do
    it { should be_file }
end

describe file('/var/www/wordpress/wp-content/plugins/plugin-check/readme.txt') do
    it { should be_file }
end

describe file('/var/www/wordpress/wp-content/plugins/dynamic-hostname/readme.txt') do
    it { should be_file }
end

