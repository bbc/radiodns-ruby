# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiodns/version"

Gem::Specification.new do |s|
  s.name        = "radiodns"
  s.version     = Radiodns::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["BBC Research and Development"]
  s.email       = ["irfs@bbc.co.uk"]
  s.homepage    = "http://github.com/chrislo/radiodns"
  s.summary     = %q{Perform RadioDNS resolutions and service lookups}
  s.description = %q{Perform RadioDNS resolutions and service lookups}

  s.rubyforge_project = "radiodns"

  s.add_development_dependency "minitest"
  s.add_development_dependency "mocha"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
