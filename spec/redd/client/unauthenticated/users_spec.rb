describe Redd::Client::Unauthenticated::Users do
  describe "#user" do
    let(:user) { unauthenticated_client.user(test_username) }

    it "returns a user" do
      expect(user).to be_a(Redd::Object::User)
    end

    it "returns the user requested" do
      expect(user.name).to match(/#{test_username}/i)
    end
  end

  describe "#get_user_overview" do
    it "returns a listing"
    it "contains content only created by the user"
  end

  describe "#get_user_submitted" do
    it "returns a listing"
    it "contains only submissions"
    it "contains submissions only created by the user"
  end

  describe "#get_user_comments" do
    it "returns a listing"
    it "contains only comments"
    it "contains comments only created by the user"
  end

  describe "#get_user_liked, #get_user_disliked, #get_user_hidden, #get_user_saved, #get_user_gilded" do
    it "returns a listing"
  end
end
