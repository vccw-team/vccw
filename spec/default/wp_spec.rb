# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'yaml'
require 'shellwords'

_conf = YAML.load(
  File.open(
    'provision/default.yml',
    File::RDONLY
  ).read
)

if File.exists?(File.join(ENV["HOME"], '.vccw/config.yml'))
  _custom = YAML.load(
    File.open(
      File.join(ENV["HOME"], '.vccw/config.yml'),
      File::RDONLY
    ).read
  )
  _conf.merge!(_custom) if _custom.is_a?(Hash)
end

if File.exists?('site.yml')
  _site = YAML.load(
    File.open(
      'site.yml',
      File::RDONLY
    ).read
  )
  _conf.merge!(_site) if _site.is_a?(Hash)
end

describe command("wp user get #{Shellwords.shellescape(_conf['admin_user'])} --format=json | jq -r .roles") do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout){ should eq 'administrator' + "\n" }
end

describe command("wp eval 'echo get_locale();'") do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout){ should eq _conf['lang'] }
end

describe command("wp eval \"bloginfo('name');\"") do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout){ should eq _conf['title'] }
end

describe command("wp option get permalink_structure") do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout){ should eq _conf['rewrite_structure'] + "\n" }
end

_conf['plugins'].each do |plugin|
  describe command("wp --no-color plugin status " + Shellwords.shellescape(plugin)) do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout){ should match /Status: Active/ }
  end
end

describe command("wp --no-color theme status " + Shellwords.shellescape(_conf['theme'])) do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout){ should match /Status: Active/ }
end

_conf['options'].each do |key, value|
  describe command("wp option get " + Shellwords.shellescape(key.to_s)) do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout){ should eq value.to_s + "\n" }
  end
end
