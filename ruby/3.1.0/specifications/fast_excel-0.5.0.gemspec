# -*- encoding: utf-8 -*-
# stub: fast_excel 0.5.0 ruby lib
# stub: extconf.rb

Gem::Specification.new do |s|
  s.name = "fast_excel".freeze
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Pavel Evstigneev".freeze]
  s.date = "2024-01-01"
  s.description = "Wrapper for libxlsxwriter using ffi".freeze
  s.email = ["pavel.evst@gmail.com".freeze]
  s.extensions = ["extconf.rb".freeze]
  s.files = ["extconf.rb".freeze]
  s.homepage = "https://github.com/paxa/fast_excel".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)
  s.rubygems_version = "3.3.7".freeze
  s.summary = "Ultra Fast Excel Writer".freeze

  s.installed_by_version = "3.3.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<ffi>.freeze, ["> 1.9", "< 2"])
  else
    s.add_dependency(%q<ffi>.freeze, ["> 1.9", "< 2"])
  end
end
