# frozen_string_literal: true

require_relative '../lib/redd'
require_relative 'support/stub_client'

def client
  @client ||= StubClient.new
end

def stub_api(verb, path, params = {}, &block)
  allow(client).to receive(verb, &block).with(path, hash_including(params))
end

def response(body, status: 200, headers: {})
  StubClient::Response.new(status, headers, body)
end
