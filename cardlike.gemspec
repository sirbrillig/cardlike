# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cardlike/version'

Gem::Specification.new do |gem|
  gem.name          = "cardlike"
  gem.version       = Cardlike::VERSION
  gem.authors       = ["Payton Swick"]
  gem.email         = ["payton@foolord.com"]
  gem.summary       = 'A library for developing and testing card games.'
  gem.homepage      = "https://github.com/sirbrillig/cardlike"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec'
  gem.add_dependency 'activesupport'
end
