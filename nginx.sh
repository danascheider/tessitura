#! /usr/bin/env bash

sudo -i
apt-get update
apt-get install -y libcurl4-openssl-dev vim libpcre3-dev zlib1g-dev
apt-get install -y vim # you're welcome

if [ ! -d "~/src" ]; then 
  mkdir src
fi 

cd src
wget http://nginx.org/download/nginx-1.7.4.tar.gz
tar -zxf nginx-1.7.4.tar.gz
cd nginx-1.7.4
./configure --user=root --group=www-data --with-http_ssl_module --with-http_realip_module --with-ipv6 --with-debug
make 
make install

# Symbolic link for the nginx binary goes in /usr/bin so 
# nginx command can be used
ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
nginx

# Install RVM stable version, RubyGems, and Bundler
\curl -sSL https://get.rvm.io | bash -s stable --ruby
apt-get install -y rubygems

mkdir /var/www && cd /var/www
apt-get install -y git
git clone https://github.com/danascheider/canto && cd canto

exit # Don't run bundle install with root privileges
bundle install