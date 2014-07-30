require "rspec"
require "webmock"
require "vcr"

require "redd"

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
  
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.around :each do |example|
    VCR.use_cassette example.metadata[:full_description] do
      example.run
    end
  end
end
