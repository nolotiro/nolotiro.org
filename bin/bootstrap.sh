#!/usr/bin/env bash

MYSQL_PASS=sincondiciones

# TODO: check installed packages

# Prepare MySQL for unattended installation
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password ${MYSQL_PASS}"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password ${MYSQL_PASS}"

# Application dependencies
apt-get install -y phantomjs \
                   redis-server \
                   mysql-server-5.5 \
                   libmysqlclient-dev \
                   imagemagick

# Rbenv dependencies
apt-get install -y curl \
                   git-core \
                   make \
                   build-essential \
                   libssl-dev \
                   libreadline6-dev \
                   zlib1g-dev \
                   libyaml-dev \
                   sqlite3 \
                   libsqlite3-dev \
                   libc6-dev

# Enable auto-login for MySQL
cat > /home/vagrant/.my.cnf <<EOF
[client]
user = root
password = $MYSQL_PASS
EOF

# Install rbenv
sudo -u vagrant -i git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv

# Load rbenv on login
sudo -u vagrant echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.profile
sudo -u vagrant echo 'eval "$(rbenv init -)"' >> /home/vagrant/.profile

# Install ruby-build
sudo -u vagrant -i git clone git://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build

# Install required ruby versions
sudo -u vagrant -i rbenv install 2.3.1
sudo -u vagrant -i rbenv global 2.3.1
sudo -u vagrant -i gem install bundler
sudo -u vagrant -i rbenv rehash

cd /vagrant
sudo -u vagrant /home/vagrant/.rbenv/shims/bundle install

sudo -u vagrant bin/rake db:drop
sudo -u vagrant bin/rake db:setup
sudo -u vagrant bin/rake max_mind:extract
