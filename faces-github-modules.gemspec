# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "faces-github-modules/version"

Gem::Specification.new do |s|
  s.name              = "faces-github-modules"
  s.version           = Faces::GithubModules::VERSION
  s.platform          = Gem::Platform::RUBY
  s.has_rdoc          = false
  s.extra_rdoc_files  = ["LICENSE" ]
  s.authors           = ["James Turnbull"]
  s.email             = ["james@lovedthanlost.net"]
  s.homepage          = "https://github.com/jamtur01/faces-github-modules"
  s.summary           = %q{A Puppet Face for managing Github Puppet Module}
  s.description       = s.summary
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths     = ["lib"]

  s.add_dependency "launchy", "~> 0.4.0"
  s.add_dependency "puppet", "~> 2.7.0"
end
