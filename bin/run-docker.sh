#!/usr/bin/env bash

set -eux

RUBY=$(mktemp)

cat << EOS > $RUBY
require 'yaml';
require 'json';

conf = YAML.load_file( "provision/default.yml" );

if ENV['ANSIBLE_ENV'].instance_of?( String )
  site = JSON.parse( ENV['ANSIBLE_ENV'] );
  conf.merge!( site ) if site.is_a?( Hash );
end

conf[:vagrant_dir] = "/vagrant";
puts JSON.generate( { :vccw => conf } );
EOS

docker pull vccw/vccw-xenial64

docker run -idt --name vccw-test -p 80:80 -p 443:443 -p 3306:3306 \
--privileged \
--volume="$(pwd)":${VM_DIR}/:rw \
vccw/vccw-xenial64:latest \
"/sbin/init"

docker exec --user ubuntu --tty vccw-test \
env TERM=xterm ansible-playbook ${VM_DIR}/provision/playbook.yml -e "$(ruby $RUBY)"
