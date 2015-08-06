# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "redd/version"

Gem::Specification.new do |spec|
  spec.name          = "redd"
  spec.version       = Redd::VERSION
  spec.authors       = ["Avinash Dwarapu"]
  spec.email         = ["avinash@dwarapu.me"]
  spec.summary       = "A Reddit API Wrapper for Ruby."
  spec.homepage      = "https://github.com/avidw/redd"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.1.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10.6"
  spec.add_development_dependency "rake", "~> 10.4.2"
  spec.add_development_dependency "rspec", "~> 3.2.0"
  spec.add_development_dependency "vcr", "~> 2.9.3"
  spec.add_development_dependency "webmock", "~> 1.20.4"

  spec.add_dependency "hashie", "~> 3.4.0"
  spec.add_dependency "faraday", "~> 0.9.1"
  spec.add_dependency "multi_json", "~> 1.10.1"
  spec.add_dependency "fastimage", "~> 1.6.6"
end
