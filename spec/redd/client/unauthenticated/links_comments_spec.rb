describe Redd::Client::Unauthenticated::LinksComments do
  describe "#get_info" do
    it "returns a listing"
    it "returns the correct objects"
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
