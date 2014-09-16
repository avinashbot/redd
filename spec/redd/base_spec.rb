describe Redd::Base do
  before do
    stub_const "ReddObject", Class.new(Redd::Base)
    ReddObject.attr_reader :string
    ReddObject.attr_reader :condition
    ReddObject.attr_reader :nonexistent
  end

  let(:base) do
    client = Redd::Client::Unauthenticated.new
    object = {
      kind: "test_object",
      data: {
        string: "test", condition: true,
        nonexistent: nil, undocumented: :accessible
      }
    }
    ReddObject.new(client, object)
  end

  it "defines an attribute method" do
    expect(base.string).to      eq("test")
    expect(base.condition).to   eq(true)
    expect(base.nonexistent).to eq(nil)
  end

  it "defines a predicate method" do
    expect(base.string?).to      eq(true)
    expect(base.condition?).to   eq(true)
    expect(base.nonexistent?).to eq(false)
  end

  it "returns undocumented attributes via #attributes" do
    expect(base.attributes[:undocumented]).to eq(:accessible)
  end
end
