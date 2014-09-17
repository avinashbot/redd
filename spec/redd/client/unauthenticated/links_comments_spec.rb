describe Redd::Client::Unauthenticated::LinksComments do
  describe "#get_info" do
    let(:response) { unauthenticated_client.get_info(id: test_link_id) }

    it "returns a listing" do
      expect(response).to be_a(Redd::Object::Listing)
    end

    it "returns the correct objects" do
      link = response.things.first
      expect(link).to be_a(Redd::Object::Submission)
      expect(link.fullname).to eq(test_link_id)
    end
  end

  describe "#submission_comments" do
    it "returns a listing of comments and morecomments only"
  end

  describe "#get_replies" do
    it "returns a listing of comments and morecomments only"
  end

  describe "expand_morecomments" do
    it "returns a listing of comments only"
    it "returns the same number of comments as it indicated" 
  end
end
