describe Redd::Client::Unauthenticated::Listing do
  describe "#by_id" do
    let(:response) { unauthenticated_client.by_id(test_link_id) }
    
    it "returns a listing" do
      expect(response).to be_a(Redd::Object::Listing)
    end

    it "returns the correct object" do
      link = response.things.first
      expect(link).to be_a(Redd::Object::Submission)
      expect(link.fullname).to eq(test_link_id)
    end
  end

  describe "#hot, #new, #top, #controversial" do
    it "returns a listing of submissions only"
  end

  describe "#comments" do
    it "returns a listing of comments only"
  end
end
