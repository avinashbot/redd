describe Redd::Client::Unauthenticated::Subreddits do
  describe "#subreddit" do
    let(:subreddit) { unauthenticated_client.subreddit(test_subreddit) }

    it "returns a subreddit object" do
      expect(subreddit).to be_a(Redd::Object::Subreddit)
    end

    it "returns the correct subreddit" do
      expect(subreddit.display_name).to eq(test_subreddit)
    end
  end

  describe "#get_subreddits" do
    let(:subreddits) { unauthenticated_client.get_subreddits }

    it "returns a listing" do
      expect(subreddits).to be_a(Redd::Object::Listing)
    end

    it "returns a listing of subreddits"
  end

  describe "#search_subreddits" do
    let(:search) { unauthenticated_client.search_subreddits(test_subreddit) }

    it "returns a listing" do
      expect(search).to be_a(Redd::Object::Listing)
    end

    it "returns a listing of subreddits"

    it "includes the subreddit searched for"
  end
end
