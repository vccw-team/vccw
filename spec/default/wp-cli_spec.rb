# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'

describe host($conf['hostname']) do
  it { should be_resolvable.by('hosts') }
end

describe interface('enp0s8') do
  it { should have_ipv4_address($conf['ip']) }
end

describe package('apache2') do
  it { should be_installed }
end

describe service('apache2') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
    it { should be_listening }
end

describe port(443) do
    it { should be_listening }
end

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

describe command('wp --version') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
end

describe command("wget -q http://" + File.join($conf['ip'], $conf['wp_home'], '/') + " -O - | head -100 | grep generator") do
    its(:stdout) { should match /<meta name="generator" content="WordPress .*"/i }
end

describe command("wget -q http://" + File.join($conf['ip'], $conf['wp_siteurl'], '/readme.html')) do
    its(:exit_status) { should eq 0 }
end

describe command("wget --no-check-certificate -q https://" + File.join($conf['ip'], $conf['wp_home'], '/') + " -O - | head -100 | grep generator") do
    its(:stdout) { should match /<meta name="generator" content="WordPress .*"/i }
end

describe file(File.join($conf['document_root'], $conf['wp_home'])) do
    let(:disable_sudo) { true }
    it { should be_directory }
    it { should be_owned_by $conf['user'] }
end

describe file(File.join($conf['document_root'], $conf['wp_siteurl'])) do
    let(:disable_sudo) { true }
    it { should be_directory }
    it { should be_owned_by $conf['user'] }
end

describe file(File.join($conf['document_root'], $conf['wp_home'], '.htaccess')) do
  let(:disable_sudo) { true }
  it { should be_file }
  it { should be_owned_by $conf['user'] }
end

describe file(File.join($conf['document_root'], $conf['wp_home'], '.gitignore')) do
    let(:disable_sudo) { true }
    it { should be_file }
    it { should be_owned_by $conf['user'] }
end

describe file(File.join($conf['document_root'], $conf['wp_home'], 'index.php')) do
  let(:disable_sudo) { true }
  it { should be_file }
  it { should be_owned_by $conf['user'] }
end

describe file(File.join($conf['document_root'], $conf['wp_siteurl'], 'wp-load.php')) do
  let(:disable_sudo) { true }
  it { should be_file }
  it { should be_owned_by $conf['user'] }
end

describe file(File.join($conf['document_root'], '.editorconfig')) do
  let(:disable_sudo) { true }
  it { should be_file }
  it { should be_owned_by $conf['user'] }
end
