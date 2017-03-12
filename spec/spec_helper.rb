# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'webmock/rspec'
require 'vcr'

require_relative '../lib/redd'
require_relative 'support/api_helpers'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { record: :all }
  config.after_http_request(:real?) { sleep(1) }
  config.configure_rspec_metadata!

  # Filter out sensitive environment variables.
  %w(PASSWORD CLIENT_ID SECRET).each do |key|
    config.filter_sensitive_data("<#{key}>") { ENV[key] }
  end

  # Filter out the access token from the request header.
  config.filter_sensitive_data('<ACCESS_TOKEN>') do |interaction|
    interaction.response.headers['Authorization'].sub('Bearer ', '')
  end
end

RSpec.configure do |config|
  config.include APIHelpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.default_formatter = 'doc' if config.files_to_run.one?
end
