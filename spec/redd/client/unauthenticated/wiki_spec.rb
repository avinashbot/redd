describe Redd::Client::Unauthenticated::Wiki do
  describe "#get_wikipages" do
    let(:pages) { unauthenticated_client.get_wikipages(test_subreddit) }

    it "returns an array of pages in the wiki" do
      expect(pages).to be_an(Array)
      expect(pages).to include(test_wikipage)
    end
  end

  describe "#wikipage" do
    let(:page) { unauthenticated_client.wikipage(test_wikipage, test_subreddit) }

    it "returns a wikipage" do
      expect(page).to be_a(Redd::Object::WikiPage)
    end
  end
end
