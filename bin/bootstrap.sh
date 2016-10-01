#!/usr/bin/env bash

# TODO: check installed packages
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password ${MYSQL_PASS}"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password ${MYSQL_PASS}"

# Servers
apt-get install -y curl phantomjs redis-server mysql-server-5.5 libmysqlclient-dev sqlite3 libsqlite3-dev imagemagick

# Para compilar Ruby con rbenv
apt-get install -y git-core make build-essential libssl-dev libreadline6-dev zlib1g-dev libyaml-dev libssl-dev libc6-dev

cat > /home/vagrant/.my.cnf <<EOF
[client]
user = root
password =
EOF

# install rbenv and ruby-build
sudo -u vagrant -i git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv

sudo -u vagrant echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.profile
sudo -u vagrant echo 'eval "$(rbenv init -)"' >> /home/vagrant/.profile

sudo -u vagrant -i git clone git://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build

# install required ruby versions
sudo -u vagrant -i rbenv install 2.3.1
sudo -u vagrant -i rbenv global 2.3.1
sudo -u vagrant -i gem install bundler
sudo -u vagrant -i rbenv rehash

cd /vagrant
sudo -u vagrant /home/vagrant/.rbenv/shims/bundle install

sudo -u vagrant bin/rake db:drop
sudo -u vagrant bin/rake db:setup
sudo -u vagrant bin/rake max_mind:extract
