# frozen_string_literal: true

require_relative 'stub_client'

module APIHelpers
  def client
    StubClient.new
  end

  def stub_api(verb, path, params = {}, &block)
    if params.empty?
      allow_any_instance_of(StubClient).to receive(verb, &block).with(path)
    else
      allow_any_instance_of(StubClient).to receive(verb, &block).with(path, params)
    end
  end

  def response(body, status: 200, headers: {})
    StubClient::Response.new(status, headers, body)
  end
end
