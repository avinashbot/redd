require "uri"

describe Redd::Client::Unauthenticated::Moderation do
  describe "#stylesheet_url" do
    it "returns a valid url" do
      url = unauthenticated_client.stylesheet_url(test_subreddit)
      expect(url).to match(URI::ABS_URI)
    end
  end

  describe "#stylesheet" do
    it "returns valid CSS" # Yeah, nope.
  end
end
