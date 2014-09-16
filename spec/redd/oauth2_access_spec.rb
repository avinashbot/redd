describe Redd::OAuth2Access do
  let(:access) do
    Redd::OAuth2Access.new
  end

  it "has an accessible access token"

  it "has an accessible duration"

  it "has an array of scopes"

  it "shows the correct time of expiry"

  describe "#refresh" do
    before do
      response = {access_token: "NEW_ACCESS_TOKEN", expires_at: 1600}
      access.refresh(response)
    end

    it "sets the new access token"

    it "sets the new expiry time"
  end

  describe "#expired?" do
    context "when the access token isn't expired" do
      it "returns false"
    end

    context "when the access token is expired" do
      it "returns true"
    end
  end

  describe "#to_json" do
    let(:json_str) { access.to_json }

    it "transcribes to valid json"
  end

  describe "#from_json" do
    it "creates a proper object from a JSON string"
  end
end
