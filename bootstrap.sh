#!/usr/bin/env bash

# Installing and configuring Docker:
# -------------------------------------------------------------------------

echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" >> /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

apt-get -y update
apt-get -y install \
  build-essential \
  git \
  tofrodos \
  python \
  unzip \
  apt-transport-https \
  ca-certificates \
  linux-image-extra-$(uname -r) \
  linux-image-extra-virtual

curl -fsSL https://get.docker.com/ | sh
apt-get -y autoremove
usermod -aG docker ubuntu

if [ "$http_proxy" != "" ]; then
  echo "# Trounced by vagrant!" > /etc/default/docker
  echo "export http_proxy=\"${http_proxy}\"" >> /etc/default/docker
  echo "export https_proxy=\"${https_proxy}\"" >> /etc/default/docker
fi

service docker restart

curl -s -L -o /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /dev/null
chmod +x /usr/local/bin/docker-compose

# Installing and configuring AWS sdk cli:
# -------------------------------------------------------------------------

curl -s -L -o awscli-bundle.zip https://s3.amazonaws.com/aws-cli/awscli-bundle.zip > /dev/null
unzip awscli-bundle.zip
./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
rm awscli-bundle.zip
rm -rf awscli-bundle

# Creating symlinks to config files:
# -------------------------------------------------------------------------

ln -s /home/ubuntu/shared/.aws /home/ubuntu/.aws
ln -s /home/ubuntu/shared/.gitconfig /home/ubuntu/.gitconfig
chmod 0600 /home/ubuntu/.ssh/id_rsa

echo ''
echo ''
echo 'Mior development environment successfully created.'
echo '------------------------------------------------------------------------'
echo 'Your home directory has been mapped to /home/ubuntu/shared'
echo 'The following config dirs and files have been mapped to /home/ubuntu:'
echo '  * ~/.aws'
echo '  * ~/.ssh'
echo '  * ~/.gitconfig'
echo ''
echo ''
