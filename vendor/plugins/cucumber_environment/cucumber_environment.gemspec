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

  s.add_dependency("cucumber", ">=0.8.5")
  s.add_dependency("cucumber-rails", ">=0.3.2") 
  s.add_dependency("webrat")
  s.add_dependency("zip")
  s.add_dependency("ruby-breakpoint") 
  s.add_dependency("mechanize")
  s.add_dependency("selenium")
  s.add_dependency("selenium-client") 
end
