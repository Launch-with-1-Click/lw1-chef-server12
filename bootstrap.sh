#!/usr/bin/env bash
set -ex

sudo yum update -y
sudo yum install git -y

## CONSTS
SETUP_DIR=/opt/lw1/setup

## Small Defs

function _get_pkgcloud() {
  wget "https://packagecloud.io/chef/stable/download?distro=6&filename=$1" -O ${SETUP_DIR}/$1 ;
}

function _get_s3() {
  wget "https://s3.amazonaws.com/opscode-private-chef/el/6/x86_64/$1" -O ${SETUP_DIR}/$1 ;
}


## Packages and Versions
PKG_CHEF_CORE=chef-server-core-12.0.0_rc.3-1.el5.x86_64.rpm
PKG_CHEF_MANGE=opscode-manage-1.5.4-1.el6.x86_64.rpm
PKG_CHEF_REPORT=opscode-reporting-1.1.5-1.el6.x86_64.rpm
PKG_CHEF_PUSHSERVER=opscode-push-jobs-server-1.1.1-1.el6.x86_64.rpm
PKG_CHEF_ANALITICS=opscode-analytics-1.0.1-1.el6.x86_64.rpm


## Prepare packages
sudo install -o ec2-user -g ec2-user -d ${SETUP_DIR}
_get_pkgcloud ${PKG_CHEF_CORE}
_get_s3 ${PKG_CHEF_MANGE}
_get_s3 ${PKG_CHEF_REPORT}
_get_s3 ${PKG_CHEF_PUSHSERVER}
_get_s3 ${PKG_CHEF_ANALITICS}


## Install Chef-Client
curl -L https://www.getchef.com/chef/install.sh | sudo bash

## Setup hint for ec2
sudo mkdir -p /etc/chef/ohai/hints
sudo touch /etc/chef/ohai/hints/ec2.json
echo '{}' > ./ec2.json
sudo mv ./ec2.json /etc/chef/ohai/hints/ec2.json
sudo chown root.root /etc/chef/ohai/hints/ec2.json


# ## Install Chef-Server
sudo rpm -ivh ${SETUP_DIR}/${PKG_CHEF_CORE}
sudo rpm -ivh ${SETUP_DIR}/${PKG_CHEF_MANGE}
sudo rpm -ivh ${SETUP_DIR}/${PKG_CHEF_REPORT}
# sudo rpm -ivh ${SETUP_DIR}/${PKG_CHEF_PUSHSERVER}
sudo rpm -ivh ${SETUP_DIR}/${PKG_CHEF_ANALITICS}



# ## Configure Chef-Server
# git clone https://github.com/Launch-with-1-Click/lw1-chef-server.git /tmp/chef-server
# sudo install -d /etc/chef-server
# sudo install -o root -g root -m 0640 /tmp/chef-server/files/chef-server.rb /etc/chef-server/
# sudo chef-server-ctl reconfigure
# 
# ## miscs
# 
# sudo install -o root -g root -m 0700 /tmp/chef-server/files/chef-server.cron /etc/cron.d/chef-server
# sudo install -o root -g root -m 0700 /tmp/chef-server/files/client.rb /etc/chef/
# sudo ln -s /etc/chef-server/chef-validator.pem  /etc/chef/validation.pem
# 
# sleep 10
# sudo chef-client
# 
# 
# ## setup Knife
# install -d /home/ubuntu/.chef
# sudo install -o ubuntu -g ubuntu -m 0644 /tmp/chef-server/files/knife.rb /home/ubuntu/.chef/
# 
