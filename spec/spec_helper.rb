# frozen_string_literal: true

require 'webmock/rspec'
require 'simplecov'
SimpleCov.start

require_relative '../lib/redd'
require_relative 'support/api_helpers'

RSpec.configure do |c|
  c.include APIHelpers
end
