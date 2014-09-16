describe Redd::Thing do
  before do
    stub_const "ReddThing", Class.new(Redd::Thing)
    ReddThing.attr_reader :string
    ReddThing.attr_reader :condition
    ReddThing.attr_reader :nonexistent
  end

  let(:thing) do
    client = Redd::Client::Unauthenticated.new
    object = {kind: "tx", data: {id: "abc123"}}
    ReddThing.new(client, object)
  end

  it "has a kind" do
    expect(thing.kind).to be_a(String)
  end

  it "has an id" do
    expect(thing.id).to be_a(String)
  end
end
