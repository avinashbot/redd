# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "redd/version"

Gem::Specification.new do |s|
  s.name          = "redd"
  s.version       = Redd::VERSION
  s.authors       = ["Avinash Dwarapu"]
  s.email         = ["d.nash.avi@gmail.com"]
  s.summary       = "A Reddit API Wrapper for Ruby."
  s.description   = "A Reddit API Wrapper for Ruby."
  s.homepage      = ""
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(/^bin\//) { |f| File.basename(f) }
  s.test_files    = s.files.grep(/^(test|spec|features)\//)
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "rake"
  s.add_development_dependency "yard"
  s.add_development_dependency "rspec"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"

  s.add_dependency "faraday", "~> 0.9.0"
  s.add_dependency "multi_json", "~> 1.10"
  s.add_dependency "memoizable"
end
