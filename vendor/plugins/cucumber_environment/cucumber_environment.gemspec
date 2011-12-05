# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cucumber_environment/version"

Gem::Specification.new do |s|
  s.name        = "cucumber_environment"
  s.version     = CucumberEnvironment::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ingo Wassink"]
  s.email       = ["Ingo Wassink - Nedap.com"]
  s.homepage    = ""
  s.summary     = %q{Easy to use cucumber installation for rails}
  s.description = %q{Easy to use cucumber installation for rails}

  s.rubyforge_project = "cucumber_environment"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("cucumber", "=0.9.4")
  s.add_dependency("cucumber-rails", "=0.3.2") 
  s.add_dependency("webrat", "=0.7.3")
  s.add_dependency("zip", "=2.0.2")
  s.add_dependency("ruby-breakpoint", "0.5.1") 
  s.add_dependency("mechanize", "=1.0.0")
  s.add_dependency("selenium", "=0.1.0")
  s.add_dependency("selenium-client", "=1.2.18")
end
