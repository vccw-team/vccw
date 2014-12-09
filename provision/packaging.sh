#!/usr/bin/env

VAGRANT_VAGRANTFILE=Vagrantfile.sample vagrant ssh -c 'sudo yum install -y gcc kernel-devel'
VAGRANT_VAGRANTFILE=Vagrantfile.sample vagrant ssh -c 'sudo yum -y distro-sync'
VAGRANT_VAGRANTFILE=Vagrantfile.sample vagrant reload


VAGRANT_VAGRANTFILE=Vagrantfile.sample vagrant ssh -c 'sudo ln -s -f /dev/null /etc/udev/rules.d/70-persistent-net.rules'
VAGRANT_VAGRANTFILE=Vagrantfile.sample vagrant ssh -c 'sudo /etc/init.d/vboxadd setup'
VAGRANT_VAGRANTFILE=Vagrantfile.sample vagrant ssh -c 'rm -fr /var/www/wordpress/*'
VAGRANT_VAGRANTFILE=Vagrantfile.sample vagrant ssh -c 'history -c'
VAGRANT_VAGRANTFILE=Vagrantfile.sample vagrant package
