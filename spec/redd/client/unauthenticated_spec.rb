describe Redd::Client::Unauthenticated, :vcr do
  let(:client) { Redd::Client::Unauthenticated.new }

  it "has configurable options" do
    newclient = Redd::Client::Unauthenticated.new(
      rate_limit: "SPEC_RATELIMIT",
      user_agent: "SPEC_USERAGENT",
      api_endpoint: "SPEC_ENDPOINT.COM"
    )

    expect(newclient.rate_limit).to eq("SPEC_RATELIMIT")
    expect(newclient.user_agent).to eq("SPEC_USERAGENT")
    expect(newclient.api_endpoint).to eq("SPEC_ENDPOINT.COM")
  end
end