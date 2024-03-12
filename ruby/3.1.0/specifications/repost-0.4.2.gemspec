# -*- encoding: utf-8 -*-
# stub: repost 0.4.2 ruby lib

Gem::Specification.new do |s|
  s.name = "repost".freeze
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://github.com/vergilet/repost" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["YaroslavO".freeze]
  s.bindir = "exe".freeze
  s.date = "2023-11-10"
  s.description = "Helps to make POST 'redirect', but actually builds [form] with method: :post under the hood".freeze
  s.email = ["osyaroslav@gmail.com".freeze]
  s.homepage = "https://github.com/vergilet/repost".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.7".freeze
  s.summary = "Gem implements Redirect using POST method".freeze

  s.installed_by_version = "3.3.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.1"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.12"])
  else
    s.add_dependency(%q<rake>.freeze, ["~> 13.1"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.12"])
  end
end
