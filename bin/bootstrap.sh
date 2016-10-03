#!/usr/bin/env bash

# Install rbenv
git clone git://github.com/sstephenson/rbenv.git "$HOME/.rbenv"

# Load rbenv on login
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> "$HOME/.profile"
echo 'eval "$(rbenv init -)"' >> "$HOME/.profile"

# Install ruby-build
git clone git://github.com/sstephenson/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"

# Make sure rbenv is available
source "$HOME/.profile"

# Install required ruby versions
rbenv install 2.3.1
rbenv global 2.3.1
gem install bundler
rbenv rehash

cd /vagrant || exit
bundle install

bin/rake db:drop
bin/rake db:setup
bin/rake max_mind:extract
