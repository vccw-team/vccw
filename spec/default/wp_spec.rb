# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'

describe command("wp user get #{Shellwords.shellescape($conf['admin_user'])} --format=json | jq -r .roles") do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout){ should eq 'administrator' + "\n" }
end

describe command("wp user get #{Shellwords.shellescape($conf['admin_user'])} --format=json | jq -r .user_email") do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout){ should eq $conf['admin_email'] + "\n" }
end

describe command("wp eval 'echo get_locale();'") do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout){ should eq $conf['lang'] }
end

describe command("wp eval \"bloginfo('name');\"") do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout){ should eq $conf['title'] }
end

$conf['plugins'].each do |plugin|
  describe command("wp --no-color plugin status " + Shellwords.shellescape(plugin)) do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout){ should match /Status: Active/ }
  end
end

describe command("wp --no-color theme status " + Shellwords.shellescape($conf['theme'])) do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stdout){ should match /Status: Active/ }
end

$conf['options'].each do |key, value|
  describe command("wp option get " + Shellwords.shellescape(key.to_s)) do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout){ should eq value.to_s + "\n" }
  end
end

#
# Multi site
#
if true == $conf['multisite']
  describe command("wp eval 'echo WP_ALLOW_MULTISITE;'") do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout){ should eq '1' }
  end
  describe command("wp option get permalink_structure") do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout){ should eq '/blog/%year%/%monthnum%/%day%/%postname%/' + "\n" }
  end
else
  describe command("wp option get permalink_structure") do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout){ should eq $conf['rewrite_structure'] + "\n" }
  end
end
