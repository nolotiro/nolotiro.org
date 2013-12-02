# nolotiro.org v3

This is the next revision of nolotiro.org, this time in Ruby On Rails.

* Ruby: 2.0.0p247
* Rails: 4.0.1

We recommend using RVM or rbenv to set up the gems. 

To install it you should do something like: 


    $ bundle
    $ cp config/app_config.yml.example config/app_config.yml
    $ cp config/database.yml.example config/database.yml
    $ rails s

The database we use is legacy, a MySQL with the schema of [v2](https://github.com/alabs/nolotiro)

For the WOEID we use [Yahoo GeoPlanet](http://developer.yahoo.com/geo/geoplanet/),
so you need to register, create a new app and configure it in the relevant environment in
*config/app_config.yml* (key *geoplanet_app_id*)

For the GeoLocation we use [GeoLiteCity](http://dev.maxmind.com/geoip/legacy/geolite/). 

    $ cd vendor/geolite
    $ wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
    $ gunzip GeoLiteCity.dat.gz

For the search we use Sphinx, so you'll need to install it: 

    $ sudo apt-get install sphinxsearch
    $ rake ts:index
    $ rake ts:start

For delayed tasks (like sending emails) we use Resque, that uses Redis. Also we use Redis to cache things. 

    $ sudo apt-get install redis-server
    $ rake resque:work QUEUE='*'

For recaptcha you need to [signup](https://www.google.com/recaptcha/admin/create)
and configure it in the relevant environment in *config/app_config.yml* (keys 
*recaptcha_public_key* and *recaptcha_private_key*)

## Development environment magic

To speed up things in development we recommend using zeus.

    $ gem install zeus
    $ zeus start 

And leave that console, restart it only when making change in Factories and when
trange things start to happen (TODO: install and configure guard). Then you can 
execute very fast (less than 1-2 seconds) some rails commands: 

    $ zeus server
    $ zeus console

Also we recommend using mailcatcher. This doesn't send external emails during
development, and you can see them in a nice web interface. The SMTP port is 
already configured to it (1025).

    $ mailcatcher
    $ open http://localhost:1080

We use a special task for the colors: 
    $ rake color_routes

We use better_errors when giving a 500 in development env. 

We use rails_footnotes in development so below the footer you have
some useful information (SQL queries executed and such). 

Happy hacking!

## API 

### v1

Example URLs: 

http://beta.nolotiro.org/api/v1/woeid/list 
http://beta.nolotiro.org/api/v1/woeid/766273/give
http://beta.nolotiro.org/api/v1/woeid/766273/give?page=2
http://beta.nolotiro.org/api/v1/ad/153735

## stats 12/11/2013

* Ads: 97206
* Images: 75384
