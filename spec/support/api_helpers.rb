# frozen_string_literal: true

require_relative 'stub_client'

module APIHelpers
  def client
    @client ||= StubClient.new
  end

  def stub_api(verb, path, params = {}, &block)
    if params.empty?
      allow(client).to receive(verb, &block).with(path)
    else
      allow(client).to receive(verb, &block).with(path, params)
    end
  end

  def response(body, status: 200, headers: {})
    StubClient::Response.new(status, headers, body)
  end
end
