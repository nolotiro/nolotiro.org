#!/usr/bin/env bash

MYSQL_PASS=sincondiciones

# TODO: check installed packages

# Prepare MySQL for unattended installation
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password ${MYSQL_PASS}"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password ${MYSQL_PASS}"

# Application dependencies
apt-get install -y imagemagick \
                   libmysqlclient-dev \
                   mysql-server-5.5 \
                   phantomjs \
                   redis-server

# Rbenv dependencies
apt-get install -y build-essential \
                   curl \
                   git-core \
                   libc6-dev \
                   libreadline6-dev \
                   libsqlite3-dev \
                   libssl-dev \
                   libyaml-dev \
                   make \
                   sqlite3 \
                   zlib1g-dev

# Enable auto-login for MySQL
cat > "$HOME/.my.cnf" <<EOF
[client]
user = root
password = $MYSQL_PASS
EOF

# Install rbenv
sudo -u vagrant -i git clone git://github.com/sstephenson/rbenv.git "$HOME/.rbenv"

# Load rbenv on login
sudo -u vagrant echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> "$HOME/.profile"
sudo -u vagrant echo 'eval "$(rbenv init -)"' >> "$HOME/.profile"

# Install ruby-build
sudo -u vagrant -i git clone git://github.com/sstephenson/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"

# Install required ruby versions
sudo -u vagrant -i rbenv install 2.3.1
sudo -u vagrant -i rbenv global 2.3.1
sudo -u vagrant -i gem install bundler
sudo -u vagrant -i rbenv rehash

cd /vagrant || exit
sudo -u vagrant bundle install

sudo -u vagrant bin/rake db:drop
sudo -u vagrant bin/rake db:setup
sudo -u vagrant bin/rake max_mind:extract
