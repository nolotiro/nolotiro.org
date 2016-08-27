# nolotiro.org v3

[![Build Status](https://travis-ci.org/alabs/nolotiro.org.png?branch=master)](https://travis-ci.org/alabs/nolotiro.org)

[![Dependency Status](https://gemnasium.com/alabs/nolotiro.org.svg)](https://gemnasium.com/alabs/nolotiro.org)

This is the next revision of nolotiro.org, this time in Ruby On Rails.

* Ruby: 2.3.1
* Rails: 4.2.6

## Automatic Installation

You need to install [VirtualBox](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com/):

Then from the root directory of the project, execute:

```
vagrant up
 ```

When finished, you need to log in to the virtual machine with the command:

```
vagrant ssh

```


Finally you should start the application server:
```
cd /vagrant
bin/rails s -b 0.0.0.0
```

Now you can access the web application at this url (port 3000):

http://localhost:3000


## Manual Installation

Check out the script in bin/bootstrap.sh - that's the same that Vagrant uses.


## Test setup

Running `bin/rake` will run all the tests, that should always pass only a
freshly downloaded copy a nolotiro's master.

Some of our integration tests use `poltergeist` + `phantomjs` to run against a
real headless browser. Currently, because of
https://github.com/ariya/phantomjs/issues/13953 and
https://github.com/travis-ci/travis-ci/issues/3225 we are providing the
phantomjs's linux x86_64 binary within the repo itself.


## More information

The database we use is legacy, a MySQL with the schema of [v2](https://github.com/alabs/nolotiro)

For obtaining geographical information we use [Yahoo YQL].

For IP GeoLocation we use [GeoLite2] City. To download the database, run

```
bin/rake download_maxmind_db
```

For delayed tasks (like sending emails) we use Sidekiq, that uses Redis. Also we use Redis to cache things.

```
sudo apt-get install redis-server
bundle exec sidekiq
```

For recaptcha you need to [signup](https://www.google.com/recaptcha/admin/create)
and configure it in the relevant environment in *config/secrets.yml* (keys
*recaptcha.public_key* and *recaptcha.private_key*)

## Development environment magic

For the emails we recommend using mailcatcher. This doesn't send external emails during
development, and you can see them in a nice web interface. The SMTP port is
already configured to it (1025).

```
bin/mailcatcher
open http://localhost:1080
```

We use a special task for the colors: 

```
rake color_routes
```

We use better_errors when giving a 500 in development env.

Happy hacking!

## i18n

For the localization and translation interface we use [LocaleApp](http://accounts.localeapp.com/projects/6872).

## API

### v1

Example URLs:

http://beta.nolotiro.org/api/v1/woeid/list
http://beta.nolotiro.org/api/v1/woeid/766273/give
http://beta.nolotiro.org/api/v1/woeid/766273/give?page=2
http://beta.nolotiro.org/api/v1/ad/153735

## 3erd Party

* Core based on [Ruby On Rail](http://rubyonrails.org/)
* [Yahoo YQL](https://developer.yahoo.com/yql) - This project is strong WOEID integration centered.
* [jQuery](http://jquery.com/) for Javascript.
* [GeoLite2][] data API by Maxmind to auto detect user location.
* Logo by [Silvestre Herrera](http://www.silvestre.com.ar/) under GPL License.

[Geolite2]: https://dev.maxmind.com/geoip/geoip2/geolite2/
