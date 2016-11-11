# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'

describe file("/home/vagrant/.wp-i18n/makepot.php") do
  let(:disable_sudo) { true }
  it { should be_file }
end

describe file('/vagrant/Movefile') do
  let(:disable_sudo) { true }
  it { should be_file }
end

commands = [
  "phpunit --version",
  "phpcs --help",
  "composer --version",
  "wordmove help",
  "wp help",
  "wp help scaffold movefile",
  "mailcatcher --version",
  "bundle help"
]

commands.each do |command|
  describe command('bash -lc "' + command + '"') do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
  end
end

#
# Check exsist database for test suite.
#
describe command('echo "show databases;" | mysql -uroot -pwordpress') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /wordpress_test/ }
end
