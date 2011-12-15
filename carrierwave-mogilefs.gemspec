# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "carrierwave-mogilefs/version"

Gem::Specification.new do |s|
  s.name        = "carrierwave-mogilefs"
  s.version     = Carrierwave::Mogilefs::VERSION
  s.authors     = ["Vrieskist"]
  s.email       = ["vrieskist@gmail.com"]
  s.homepage    = "http://tjittedevries.com/"
  s.summary     = %q{MogileFS support for Carrierwave}
  s.description = %q{MogileFS support for Carrierwave}

  s.rubyforge_project = "carrierwave-mogilefs"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "carrierwave"
  # s.add_runtime_dependency "rest-client"
end
