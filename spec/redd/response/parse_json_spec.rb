RSpec.describe Redd::Response::ParseJson do
  it "parses valid JSON" do
    parsed = subject.parse('{"hello": "world", "foo": {"bar": 2}}')
    expect(parsed).to eq({hello: "world", foo: {bar: 2}})
  end

  it "returns the JSON string if it's invalid" do
    error = "comparision with banana failed."
    parsed = subject.parse(error)
    expect(parsed).to eq(error)
  end
end
