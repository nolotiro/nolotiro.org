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
so you need to register, create a new app and configure it in the relevant environment in *config/app_config.yml* (key *geoplanet_app_id*)

For the GeoLocation we use [GeoLiteCity](http://dev.maxmind.com/geoip/legacy/geolite/). 

    $ cd vendor/geolite
    $ wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
    $ gunzip GeoLiteCity.dat.gz

Happy hacking!

## stats 12/11/2013

* Ads: 97206
* Images: 75384

