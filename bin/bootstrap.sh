#!/usr/bin/env bash

# Install rbenv
git clone git://github.com/sstephenson/rbenv.git "$HOME/.rbenv"

# Load rbenv on login
cat > "$HOME/.profile" <<'EOF'
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
EOF

# Install ruby-build
git clone git://github.com/sstephenson/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"

# Make sure rbenv is available
source "$HOME/.profile"

# Install required ruby versions
rbenv install 2.4.1

cd /vagrant || exit

gem install bundler
rbenv rehash

bundle install

bin/rake db:reset RAILS_ENV=development
bin/rake db:drop db:create db:structure:load RAILS_ENV=test
bin/rake max_mind:extract
