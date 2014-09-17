require "rspec"
require "webmock"
require "vcr"

require "redd"

def test_username; ENV["REDDIT_USERNAME"]; end
def test_password; ENV["REDDIT_PASSWORD"]; end
def test_subreddit; ENV["REDDIT_SUBREDDIT"]; end

def test_link_id; ENV["REDDIT_LINKID"] || "t3_2gngbm"; end
def test_wikipage; ENV["REDDIT_WIKIPAGE"] || "redd_wiki_test"; end

def unauthenticated_client
  $unauthenticated_client ||= Redd::Client::Unauthenticated.new
end

def authenticated_client
  $authenticated_client ||= Redd::Client::Authenticated.new_from_credentials(test_username, test_password)
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.default_cassette_options = {record: :new_episodes}
  config.hook_into :webmock
  config.filter_sensitive_data("<PASSWORD>") { test_password }
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
