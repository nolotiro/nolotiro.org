#!/usr/bin/env bash
# http://docs.vagrantup.com/v2/getting-started/provisioning.html

GEOLITE_URL="http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz "
MYSQL_PASS="sincondiciones"

# TODO: check installed packages
  apt-get update
  debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password ${MYSQL_PASS}"
  debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password ${MYSQL_PASS}"
  apt-get install -y sphinxsearch build-essential curl redis-server mysql-server-5.5  libmysqlclient-dev

cat > /home/vagrant/.my.cnf <<EOF
[client]
user = root
pass = ${MYSQL_PASS}
EOF

echo "CREATE DATABASE nolotirov3_dev; GRANT ALL PRIVILEGES ON nolotirov3_dev.* TO nolotirov3@localhost IDENTIFIED BY'nolotirov3pass'; FLUSH PRIVILEGES;" | mysql

# GeoLiteCity
if [ ! -f /vagrant/vendor/geolite/GeoLiteCity.dat ] ; then
  wget --quiet --output-document gelolite.download.log $GEOLITE_URL -O /vagrant/vendor/geolite/GeoLiteCity.dat.gz
  cd /vagrant/vendor/geolite/
  gunzip GeoLiteCity.dat.gz
fi 

# RVM 
if [ ! -d /usr/local/rvm ] ; then 
  \curl -L https://get.rvm.io | bash -s stable --ruby  2> /dev/null
  source /etc/profile.d/rvm.sh
  rvm use 2.0.0 
  rvm gemset create nolotiro
fi

cat > /home/vagrant/.gemrc <<EOF
gem: --no-ri --no-rdoc
EOF

source /etc/profile.d/rvm.sh
rvm use 2.0.0
rvm gemset use nolotiro --default

cd /vagrant
bundle install

cp config/app_config.yml.example config/app_config.yml
#cp config/database.yml.example config/database.yml

mysql -uroot -p${MYSQL_PASS} << EOF
CREATE DATABASE nolotirov3; 
GRANT ALL PRIVILEGES ON nolotirov3.* TO nolotirov3@localhost IDENTIFIED BY 'nolotirov3pass';
FLUSH PRIVILEGES;
EOF

# TODO: db:seeds 
rake db:schema:load

bundle exec rake ts:index
bundle exec rake ts:start

# DEV - MailCatcher: for port 1080
mailcatcher &

# DEV - Doctor Zeus Doctor Zeus - speed up things
# http://blog.rudylee.com/2013/09/13/zeus-inside-vagrant/
export ZEUSSOCK=/tmp/zeus.sock
zeus start &
sleep 20

# DEV - Zeus Server.
zeus server

