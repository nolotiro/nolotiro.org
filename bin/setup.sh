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
