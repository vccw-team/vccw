#!/usr/bin/env bash

set -eux

RUBY=$(mktemp)

cat << EOS > $RUBY
require 'yaml';
require 'json';

conf = YAML.load_file( "provision/default.yml" );

if File.exists?( 'site.yml' )
  site = YAML.load(
    File.open(
      'site.yml',
      File::RDONLY
    ).read
  )
  conf.merge!( site ) if site.is_a?( Hash )
end

if ENV['VCCW_ENV'].instance_of?( String )
  site = JSON.parse( ENV['VCCW_ENV'] );
  conf.merge!( site ) if site.is_a?( Hash );
end

conf[:vagrant_dir] = "/vagrant";
puts JSON.generate( { :vccw => conf } );
EOS

VCCW_CONFIG=$(ruby $RUBY)
VCCW_HOSTNAME=$(echo $VCCW_CONFIG | jq -r .vccw.hostname)

docker pull vccw/vccw-xenial64

docker run -idt -p 80:80 -p 443:443 -p 3306 \
--name=${VCCW_HOSTNAME} \
--add-host=${VCCW_HOSTNAME}:127.0.0.1 \
--privileged \
--volume="$(pwd)":${VM_DIR}/:rw \
vccw/vccw-xenial64:latest \
"/sbin/init"

docker exec --tty ${VCCW_HOSTNAME} env TERM=xterm chown ubuntu:ubuntu ${VM_DIR}
docker exec --tty ${VCCW_HOSTNAME} env TERM=xterm chmod 777 ${VM_DIR}
docker exec --tty ${VCCW_HOSTNAME} env TERM=xterm mkdir ${VM_DIR}/wp-cli
docker exec --tty ${VCCW_HOSTNAME} env TERM=xterm chmod 777 ${VM_DIR}/wp-cli

docker exec --user ubuntu --tty ${VCCW_HOSTNAME} \
env TERM=xterm ansible-playbook ${VM_DIR}/provision/playbook.yml -e "$(ruby $RUBY)"

docker exec --tty ${VCCW_HOSTNAME} env TERM=xterm rm -f ${VM_DIR}/wp-cli.yml
docker exec --tty ${VCCW_HOSTNAME} env TERM=xterm rm -fr ${VM_DIR}/wp-cli
