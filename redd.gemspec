# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redd/version'

Gem::Specification.new do |spec|
  spec.name          = 'redd'
  spec.version       = Redd::VERSION
  spec.authors       = ['Avinash Dwarapu']
  spec.email         = ['avinash@dwarapu.me']

  spec.summary       = 'A batteries-included API wrapper for reddit.'
  spec.homepage      = 'https://github.com/avinashbot/redd'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.1.0'

  spec.add_dependency 'http', '~> 2.2'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rubocop', '~> 0.47'
  spec.add_development_dependency 'pry', '~> 0.10'

  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'simplecov', '~> 0.13'
  spec.add_development_dependency 'webmock', '~> 2.3'
  spec.add_development_dependency 'vcr', '~> 3.0'
end
