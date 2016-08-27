# nolotiro.org

[![Build Status][Travis Badge]][Travis URL]
[![Dependency Status][Gemnasium Badge]][Gemnasium URL]

This is the next revision of nolotiro.org (v3), this time in [Ruby On Rails].

* Ruby: 2.3
* Rails: 4.2

## Automatic Installation

You need to install [VirtualBox] and [Vagrant]. Then from the root directory of
the project, execute

```
vagrant up
 ```

When finished, you need to log in to the virtual machine with the command

```
vagrant ssh

```

Finally you should start the application server

```
cd /vagrant
bin/rails s -b 0.0.0.0
```

Now you can access the web application at this URL

```
http://localhost:3000
```

## Manual Installation

Check out the script in `bin/bootstrap.sh` - that's the same that Vagrant uses.

## Test setup

Running `bin/rake` will run all the tests, that should always pass on a freshly
downloaded copy a nolotiro's master.

Some of our integration tests use `poltergeist` + `phantomjs` to run against a
real headless browser. Currently, because of [this bug][Phantomjs Bug] and
[this bug][Travis Bug] we are providing the phantomjs's linux x86_64 binary
within the repo itself.

## More information

For obtaining geographical information we use [Yahoo YQL].

For IP GeoLocation we use [GeoLite2] City. To download the database, run

```
bin/rake download_maxmind_db
```

For delayed tasks, we use Sidekiq, that uses Redis. For caching, we use Redis.

```
sudo apt-get install redis-server
bundle exec sidekiq
```

For recaptcha you need to [signup][Google Recaptcha] and configure it in the
relevant environment in *config/secrets.yml* (keys *recaptcha.public_key* and
*recaptcha.private_key*)

## Development environment magic

For the emails we recommend using mailcatcher. This doesn't send external emails
during development, and you can see them in a nice web interface. The SMTP port
is already configured.

```
bin/mailcatcher
open http://localhost:1080
```

Happy hacking!

## i18n

For the localization and translation interface we use [LocaleApp].

## API

### v1

Example URLs:

```
https://beta.nolotiro.org/api/v1/woeid/list
https://beta.nolotiro.org/api/v1/woeid/766273/give
https://beta.nolotiro.org/api/v1/woeid/766273/give?page=2
https://beta.nolotiro.org/api/v1/ad/153735
```

## 3erd Party

* Core based on [Ruby On Rails].
* [Yahoo YQL] - This project is strong WOEID integration centered.
* [jQuery] for Javascript.
* [GeoLite2] data API by Maxmind to auto detect user location.
* Logo by Silvestre Herrera under GPL License.

[Gemnasium Badge]: https://gemnasium.com/alabs/nolotiro.org.svg
[Gemnasium URL]: https://gemnasium.com/alabs/nolotiro.org
[Geolite2]: https://dev.maxmind.com/geoip/geoip2/geolite2
[Google Recaptcha]: https://www.google.com/recaptcha/admin#list
[jQuery]: https://jquery.com
[Localeapp]: https://accounts.localeapp.com/projects/6872
[Phantomjs Bug]: https://github.com/ariya/phantomjs/issues/13953
[Ruby on Rails]: http://rubyonrails.org
[Travis Badge]: https://travis-ci.org/alabs/nolotiro.org.png
[Travis Bug]: https://github.com/travis-ci/travis-ci/issues/3225
[Travis URL]: https://travis-ci.org/alabs/nolotiro.org
[Vagrant]: https://www.vagrantup.com/
[Virtualbox]: https://www.virtualbox.org/
[Yahoo YQL]: https://developer.yahoo.com/yql
