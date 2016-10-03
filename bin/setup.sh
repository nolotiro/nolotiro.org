#!/usr/bin/env bash

MYSQL_PASS=sincondiciones

# Prepare MySQL for unattended installation
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $MYSQL_PASS"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $MYSQL_PASS"

# Setup nodejs repo
curl -sL https://deb.nodesource.com/setup_6.x | bash -

# Application dependencies
apt-get install -y imagemagick \
                   libmysqlclient-dev \
                   mysql-server-5.5 \
                   nodejs \
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

cd /vagrant || exit

# Prepare DB user

source "$(pwd)/.env"
mysql -e "CREATE USER $NLT_DB_USER@localhost IDENTIFIED BY '$NLT_DB_PASS'"

source "$(pwd)/.env.development"
mysql -e "GRANT ALL PRIVILEGES ON $NLT_DB_NAME.* TO $NLT_DB_USER@localhost"

source "$(pwd)/.env.test"
mysql -e "GRANT ALL PRIVILEGES ON $NLT_DB_NAME.* TO $NLT_DB_USER@localhost"
