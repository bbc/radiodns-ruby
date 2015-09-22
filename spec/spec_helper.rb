$:.unshift(File.join(File.dirname(__FILE__),'..','lib'))

require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'minitest/autorun'
require 'mocha/mini_test'

require 'radiodns'
