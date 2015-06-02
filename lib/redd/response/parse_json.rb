require "faraday/response"
require_relative "../error"

module Redd
  # The module that contains middleware that alters the Faraday response.
  module Response
    # Faraday Middleware that parses JSON using OJ, via MultiJson.
    class ParseJson < Faraday::Response::Middleware
      dependency "multi_json"

      def on_complete(env)
        env[:body] = MultiJson.load(env[:body], symbolize_keys: true)
      rescue MultiJson::ParseError
        raise JSONError.new(env), env[:body]
      end
    end
  end
end
