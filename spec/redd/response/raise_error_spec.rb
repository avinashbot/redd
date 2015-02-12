RSpec.describe Redd::Response::RaiseError do
  it "return nil if there's no error" do
    error = subject.on_complete(
      status: 200,
      body: {success: true},
      response_headers: {}
    )

    expect(error).to be(nil)
  end
end
