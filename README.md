# RadioDNS Ruby Library

[![Gem Version](https://badge.fury.io/rb/radiodns-ruby.png)](http://rubygems.org/gems/radiodns-ruby) [![Build Status](https://travis-ci.org/bbcrd/radiodns-ruby.png?branch=master)](https://travis-ci.org/bbcrd/radiodns-ruby)

## Summary

This Ruby Gem provides utilities for working with RadioDNS. It supports service CNAME resolution from bearer parameters and application discovery, corresponding to [v0.6.1 of the RadioDNS spec](http://radiodns.org/wp-content/uploads/2009/03/rdns011.pdf).

## Installation

    gem install radiodns

## Usage

Add this to the top of your script

    require 'radiodns'

Then if you already have the Fully Qualified Domain Name as specified
in the [RadioDNS spec](http://radiodns.org/wp-content/uploads/2009/03/rdns011.pdf), you
can resolve it into a CNAME like so

    service = RadioDNS::Resolver.resolve('09580.c586.ce1.fm.radiodns.org')
    puts service.cname #=> 'rdns.musicradio.com'

You can also pass in the parameters required to construct the FQDN to
the resolve method

    params = {
      :freq => '09580',
      :pi => 'c586',
      :ecc => 'ce1',
      :bearer => 'fm'
    }
    service = RadioDNS::Resolver.resolve(params)

The bearers `fm`, `dab`, `drm`, `amss` and `hd` are supported.

Once you have a service you can perform application discovery

    radiovis_application = service.radiovis

    radiovis_application.host #=> "rdns.musicradio.com"
    radiovis_application.port #=> 61613
    radiovis_application.type #=> :radiovis

Or to get an array of supported applications

    service.applications

which returns

    [#<RadioDNS::Application @host="rdns.musicradio.com", @port=61613, @type=:radioepg>,
     #<RadioDNS::Application @host="rdns.musicradio.com", @port=61613, @type=:radiovis>]

In the future these may become instances of specific classes that
implement application-specific behaviour, but I might make those
separate gems.

## TODO

 - better error checking of supplied parameters. The code current
   checks for mandatory parameters but not if the parameters
   themselves conform to the spec (e.g. pa should be between 0 and
   1023)
