describe Redd::Client::Unauthenticated::Account do
  describe "#login" do
    let(:logged_in_client) do
      unauthenticated_client.login(test_username, test_password)
    end

    it "returns an Authenticated client" do
      expect(logged_in_client).to be_a(Redd::Client::Authenticated)
    end

    it "can be used to make requests" do
      expect(logged_in_client.me[:name]).to match(/#{test_username}/i)
    end
  end
end
