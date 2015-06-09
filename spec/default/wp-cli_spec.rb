# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'

describe host($conf['hostname']) do
  it { should be_resolvable.by('hosts') }
end

describe interface('eth1') do
  it { should have_ipv4_address($conf['ip']) }
end

describe package('httpd') do
  it { should be_installed }
end

describe service('httpd') do
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

describe command('wp --version') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
end

describe command('wp help dictator') do
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

$conf['plugins'].each do |plugin|
  describe file(File.join($conf['document_root'], $conf['wp_siteurl'], 'wp-content/plugins', plugin, 'readme.txt')) do
    let(:disable_sudo) { true }
    it { should be_file }
    it { should be_owned_by $conf['user'] }
  end
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
