require "redd/rate_limit"

RSpec.describe Redd::RateLimit do
  let(:rate_limit) { Redd::RateLimit.new(2) }

  it "waits two seconds between consecutive requests" do
    rate_limit.after_limit {}
    start_time = Time.now
    rate_limit.after_limit {}
    end_time = Time.now

    expect(end_time - start_time).to be_within(0.1).of(2)
  end

  it "doesn't wait if two seconds have passed since last request" do
    rate_limit.after_limit {}
    sleep(2)
    start_time = Time.now
    rate_limit.after_limit {}
    end_time = Time.now

    expect(end_time - start_time).to be_within(0.1).of(0)
  end

  it "stores the time the last request was made" do
    time = Time.now
    rate_limit.after_limit {}

    expect(rate_limit.last_request_time).to be_within(0.1).of(time)
  end
end
