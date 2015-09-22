# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiodns/version"

Gem::Specification.new do |s|
  s.name        = "radiodns"
  s.version     = RadioDNS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Lowis"]
  s.email       = ["chris.lowis@gmail.com"]
  s.homepage    = "http://github.com/bbcrd/radiodns"
  s.summary     = %q{Perform RadioDNS resolutions and service lookups}
  s.description = %q{Perform RadioDNS resolutions and service lookups}

  s.rubyforge_project = "radiodns"

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest', '>= 5.1.0'
  s.add_development_dependency 'mocha',    '~> 1.1.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
