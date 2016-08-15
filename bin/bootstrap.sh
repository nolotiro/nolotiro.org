#!/usr/bin/env bash
# http://docs.vagrantup.com/v2/getting-started/provisioning.html

# Servers
apt-get install -y curl redis-server mysql-server-5.6 libmysqlclient-dev imagemagick
# Para compilar Ruby con rbenv
apt-get install -y git-core make build-essential libssl-dev libreadline6-dev zlib1g-dev libyaml-dev libssl-dev libc6-dev
# Borrar la cache de los paquetes
apt-get clean

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

# no rdoc for installed gems
echo 'gem: --no-ri --no-rdoc' >> /home/vagrant/.gemrc

# install required ruby versions
sudo -u vagrant -i rbenv install 2.3.1
sudo -u vagrant -i rbenv global 2.3.1
sudo -u vagrant -i ruby -v
sudo -u vagrant -i gem install bundler --no-ri --no-rdoc
sudo -u vagrant -i rbenv rehash

cd /vagrant
sudo -u vagrant /home/vagrant/.rbenv/shims/bundle install

cp config/database.yml.example config/database.yml
cp config/secrets.yml.example config/secrets.yml

chown vagrant:vagrant config/*.yml

# TODO: db:seeds
sudo -u vagrant bin/rake db:drop
sudo -u vagrant bin/rake db:setup
sudo -u vagrant bin/rake ts:index ts:restart
sudo -u vagrant bin/rake download_maxmind_db
