# -*- encoding: utf-8 -*-
# stub: rack-flash 0.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "rack-flash"
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Pat Nakajima"]
  s.date = "2009-02-26"
  s.email = "patnakajima@gmail.com"
  s.rubygems_version = "2.4.3"
  s.summary = "Flash hash implementation for Rack apps."

  s.installed_by_version = "2.4.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
  end
end
