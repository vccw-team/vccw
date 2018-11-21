require 'spec_helper'

describe package('apache2') do
  it { should be_installed }
end

describe service('apache2') do
  it { should be_enabled }
  it { should be_running }
end

describe command('apache2ctl -M') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /rewrite_module/ }
    its(:stdout) { should match /ssl_module/ }
end

describe command("ps -C apache2 -o user") do
  its(:stdout) { should match /root/ }
  its(:stdout) { should match /#{$conf['user']}/ }
  its(:stdout) { should_not match /www-data/ }
end

describe port(80) do
  it { should be_listening }
end

describe port(443) do
  it { should be_listening }
end

describe package('mysql-server') do
  it { should be_installed }
end

describe port(3306) do
  it { should be_listening }
end

if $conf['mailcatcher'] then
  describe service('mailcatcher') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(1080) do
    it { should be_listening }
  end
end

describe command('echo "show databases;" | mysql -uroot -pwordpress') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /information_schema/ }
end

describe command('php -v') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /PHP 7\./ }
end

describe command('composer help') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
end

describe command('node -v') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /v6\./ }
end

describe command('ruby -v') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /ruby 2\.4\./ }
end

commands = %w{
  curl
  gettext
  git
  jq
  msgfmt
  msgmerge
  svn
}

commands.each do |commands|
  describe command("which " + Shellwords.shellescape(commands)) do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
  end
end

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

describe 'PHP config parameters for cli' do
  $conf['php_ini'].each do |ini_key, ini_value|
    context php_config(ini_key, :ini => '/etc/php/7.0/cli/conf.d/99-vccw.ini') do
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
