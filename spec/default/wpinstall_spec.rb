# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'

#
# Check the WordPress installation was successful.
#

# describe host($conf['hostname']) do
#   it { should be_resolvable.by('hosts') }
# end

# describe interface('enp0s8') do
#   it { should have_ipv4_address($conf['ip']) }
# end

# describe command("su -l bash -lc 'wp --version'") do
#   let(:disable_sudo) { true }
#   its(:exit_status) { should eq 0 }
# end

describe command("curl http://127.0.0.1/ | head -100 | grep generator") do
    its(:stdout) { should match /<meta name="generator" content="WordPress .*"/i }
end

describe command("curl -k https://127.0.0.1/ | head -100 | grep generator") do
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

describe file(File.join($conf['document_root'], $conf['wp_siteurl'], '.gitignore')) do
  let(:disable_sudo) { true }
  it { should be_file }
  it { should be_owned_by $conf['user'] }
end
