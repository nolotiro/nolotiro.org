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

## More information

The database we use is legacy, a MySQL with the schema of [v2](https://github.com/alabs/nolotiro)

For the WOEID we use [Yahoo GeoPlanet](http://developer.yahoo.com/geo/geoplanet/),
so you need to register, create a new app and configure it in the relevant environment in
*config/app_config.yml* (key *geoplanet_app_id*)

For the GeoLocation we use [GeoLite2] City. To download the database, run

```
bin/rake nolotiro:download_maxmind_db
```

For the search we use Sphinx, so you'll need to install it:

```
sudo apt-get install sphinxsearch
bin/rake ts:index
bin/rake ts:start
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
mailcatcher
open http://localhost:1080
```

We use a special task for the colors: 

```
rake color_routes
```

We use better_errors when giving a 500 in development env.

We use rails_footnotes in development so below the footer you have
some useful information (SQL queries executed and such).

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
* [Yahoo! Geo Planet API](http://developer.yahoo.com/geo/geoplanet/) - This project is strong WOEID integration centered.
* [jQuery](http://jquery.com/) for Javascript.
* [GeoLite2][] data API by Maxmind to auto detect user location.
* Logo by [Silvestre Herrera](http://www.silvestre.com.ar/) under GPL License.

[Geolite2]: https://dev.maxmind.com/geoip/geoip2/geolite2/
