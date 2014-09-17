require "uri" 

describe Redd::Client::Unauthenticated::Captcha do
  describe "#needs_captcha?" do
    it "returns a boolean" do
      expect(unauthenticated_client.needs_captcha?).to be(true).or be(false)
    end
  end

  describe "#new_captcha" do
    it "returns a string" do
      expect(unauthenticated_client.new_captcha).to be_a(String)
    end
  end

  describe "#captcha_url" do
    it "returns a valid url" do
      new_captcha = unauthenticated_client.new_captcha
      captcha_url = unauthenticated_client.captcha_url(new_captcha)
      expect(captcha_url).to match(URI::ABS_URI)
    end
  end
end
