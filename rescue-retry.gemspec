# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rescue/version'

Gem::Specification.new do |spec|
  spec.name          = "rescue-retry"
  spec.version       = Rescue::Retry::VERSION
  spec.authors       = ["robert2d"]
  spec.email         = ["david.robertson@crichq.com"]

  spec.summary       = %q{Rescue and Retry a instance method, whilst keeping a method free from rescue's}
  spec.description   = %q{Wraps an instance method with retry and error capture without adding logic directly to the method}
  spec.homepage      = "https://github.com/robert2d/rescue-retry"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "coveralls", "~> 0.8"
end
