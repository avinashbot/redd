require "json"

describe Redd::OAuth2Access do

  # TODO: Use the password grant with a future OAuth2Stript Client for more
  # for more accurate responses.
  let(:access) do
    Redd::OAuth2Access.new(
      access_token: "TEST_ACCESS_TOKEN",
      refresh_token: "TEST_REFRESH_TOKEN",
      scope: "identity,TEST_SCOPE",
      expires_in: 3600
    )
  end

  it "has an accessible access token" do
    expect(access.access_token).to be_a(String)
  end

  it "has an accessible duration" do
    expect(access.duration).to eq(:temporary).or eq(:permanent)
  end

  it "has an array of scopes" do
    expect(access.scope).to be_an(Array)
  end

  it "shows the correct time of expiry" do
    expect(access.expires_at).to be_within(60).of(Time.now + 3600)
  end

  describe "#refresh" do
    let(:refreshed_access) { access.dup }
    let(:new_access_token) { "NEW_ACCESS_TOKEN" }
    let(:new_expires_in) { 1600 }

    before do
      response = {access_token: new_access_token, expires_in: new_expires_in}
      refreshed_access.refresh(response)
    end

    it "sets the new access token" do
      expect(refreshed_access.access_token).to eq(new_access_token)
    end

    it "sets the new expiry time" do
      expect(refreshed_access.expires_at).to be_within(60).of(Time.now + new_expires_in)
    end
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

    it "transcribes to valid json" do
      expect(JSON.parse(json_str)).to be_a(Hash)
    end
  end

  describe "#from_json" do
    let(:object) do
      json = access.to_json
      Redd::OAuth2Access.from_json(json)
    end

    it "creates a proper object from a JSON string" do
      expect(object.access_token).to  eq(access.access_token)
      expect(object.refresh_token).to eq(access.refresh_token)
      expect(object.scope).to         eq(access.scope)
      expect(object.duration).to      eq(access.duration)
      expect(object.expires_at).to    be_within(60).of(access.expires_at)
    end
  end
end
