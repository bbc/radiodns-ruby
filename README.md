# RadioDNS Ruby Library

## Summary

This Ruby Gem provides utilities for working with the RadioDNS spec.

## Installation

    gem install radiodns

## Usage

Add this to the top of your script

    require 'radiodns'

Then if you already have the Fully Qualified Domain Name as specified
in the [RadioDNS spec](http://radiodns.org/wp-content/uploads/2009/03/rdns011.pdf), you
can resolve it into a CNAME like so

    cname = RadioDNS::Resolver.resolve('09580.c586.ce1.fm.radiodns.org')
    puts cname #=> 'rdns.musicradio.com'

You can also pass in the parameters required to construct the FQDN to
the resolve method

    params = {
      :freq => '09580',
      :pi => 'c586',
      :ecc => 'ce1',
      :bearer => 'fm'
    }
    cname = RadioDNS::Resolver.resolve(params)

The bearers `fm`, `dab`, `drm`, `amss` and `hd` are supported.

## TODO

 - better error checking of supplied parameters. The code current
   checks for mandatory parameters but not if the parameters
   themselves conform to the spec (e.g. pa should be between 0 and
   1023)

 - return an appropriate error if DNS look-up does not resolve to
   CNAME.

 - service discovery