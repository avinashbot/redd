require "faraday/response"

module Redd
  # The module that contains middleware that alters the Faraday response.
  module Response
    # Faraday Middleware that parses JSON using OJ, via MultiJson.
    class ParseJson < Faraday::Response::Middleware
      dependency "multi_json"

      def parse(body)
        MultiJson.load(body, symbolize_keys: true)
      rescue MultiJson::ParseError
        body
      end
    end
  end
end
