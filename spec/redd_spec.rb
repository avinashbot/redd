require_relative "spec_helper"

describe Redd do
  it "has a semantic version number" do
    expect(Redd::VERSION).to match(/\d\.\d\.\d/)
  end
end