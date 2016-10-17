#!/usr/bin/env bash

# Setup PostgreSQL repo
add-apt-repository \
  'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main'

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  apt-key add -

apt-get update

# Setup nodejs repo
curl -sL https://deb.nodesource.com/setup_6.x | bash -

# Application dependencies
apt-get install -y imagemagick \
                   libpq-dev \
                   postgresql-9.6 \
                   postgresql-contrib-9.6 \
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

cd /vagrant || exit

# Prepare DB user

source "$(pwd)/.env"

sudo -u postgres psql -c "CREATE USER $NLT_DB_USER WITH SUPERUSER \
                                                        CREATEDB \
                                                        NOCREATEROLE \
                                                        PASSWORD '$NLT_DB_PASS'"

# Let DB user authenticate through password

sed -i 's/\(local *all *all *\)peer/\1md5/' /etc/postgresql/9.6/main/pg_hba.conf
service postgresql reload
