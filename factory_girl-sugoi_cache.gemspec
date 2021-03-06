# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'factory_girl/sugoi_cache/version'

Gem::Specification.new do |spec|
  spec.name          = "factory_girl-sugoi_cache"
  spec.version       = FactoryGirl::SugoiCache::VERSION
  spec.authors       = ["jiikko"]
  spec.email         = ["n905i.1214@gmail.com"]

  spec.summary       = %q{preload FactoryGirl}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/jiikko/factory_girl-sugoi_cache"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "factory_girl"
  spec.add_dependency "activerecord"
  spec.add_development_dependency "rails", '4.2.7.1'
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "pry-meta"
end
