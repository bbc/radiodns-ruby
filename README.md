# RadioDNS Ruby Library

## Summary

This Ruby Gem provides utilities for working with the RadioDNS spec.

## Installation

    gem install radiodns

## Usage

    require 'radiodns'

    cname = RadioDNS::Resolver.resolve(''09580.c586.ce1.fm.radiodns.org')
    puts cname #=> 'rdns.musicradio.com'
