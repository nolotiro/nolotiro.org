#!/usr/bin/env bash
# http://docs.vagrantup.com/v2/getting-started/provisioning.html

GEOLITE_URL="http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz "
MYSQL_PASS="sincondiciones"

# TODO: check installed packages
apt-get update
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password ${MYSQL_PASS}"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password ${MYSQL_PASS}"
# Servers
apt-get install -y sphinxsearch curl redis-server mysql-server-5.5 libmysqlclient-dev sqlite3 libsqlite3-dev imagemagick
# Para compilar Ruby con rbenv
apt-get install -y git-core make build-essential libssl-dev libreadline6-dev zlib1g-dev libyaml-dev libssl-dev libc6-dev
# Para capybara-webkit
apt-get install -y g++ qt5-default libqt5webkit5-dev
# Borrar la cache de los paquetes
apt-get clean

cat > /home/vagrant/.my.cnf <<EOF
[client]
user = root
password = ${MYSQL_PASS}
EOF

# GeoLiteCity
if [ ! -f /vagrant/vendor/geolite/GeoLiteCity.dat ]
then
  sudo -u vagrant wget --quiet --output-document geolite.download.log $GEOLITE_URL -O /vagrant/vendor/geolite/GeoLiteCity.dat.gz
  cd /vagrant/vendor/geolite/
  sudo -u vagrant gunzip GeoLiteCity.dat.gz
fi

# install rbenv and ruby-build
sudo -u vagrant -i git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
sudo -u vagrant echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.profile
sudo -u vagrant echo 'eval "$(rbenv init -)"' >> /home/vagrant/.profile
sudo -u vagrant -i git clone git://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build

# no rdoc for installed gems
echo 'gem: --no-ri --no-rdoc' >> /home/vagrant/.gemrc

# install required ruby versions
sudo -u vagrant -i rbenv install 2.3.0
sudo -u vagrant -i rbenv global 2.3.0
sudo -u vagrant -i ruby -v
sudo -u vagrant -i gem install bundler --no-ri --no-rdoc
sudo -u vagrant -i rbenv rehash

cd /vagrant
sudo -u vagrant /home/vagrant/.rbenv/shims/bundle install

cp config/app_config.yml.example config/app_config.yml
cp config/database.yml.example config/database.yml
cp config/secrets.yml.example config/secrets.yml

chown vagrant:vagrant config/*.yml

# TODO: db:seeds
sudo -u vagrant /home/vagrant/.rbenv/shims/bundle exec rake db:drop
sudo -u vagrant /home/vagrant/.rbenv/shims/bundle exec rake db:setup
sudo -u vagrant /home/vagrant/.rbenv/shims/bundle exec rake ts:index
sudo -u vagrant /home/vagrant/.rbenv/shims/bundle exec rake ts:restart
