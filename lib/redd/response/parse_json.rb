require "faraday_middleware"

module Redd
  # The module that contains middleware that alters the Faraday response.
  module Response
    # Faraday Middleware that parses JSON using Oj.
    class ParseJson < Faraday::Middleware
      dependency do
        require "multi_json" unless defined?(::MultiJson)
      end

      # Call the middleware.
      # @param faraday
      def call(faraday)
        @app.call(faraday).on_complete do |env|
          env[:body] = parse(env[:body])
        end
      end

      private

      # Parse a JSON string and return a symbolized hash.
      #
      # @param [String] body The JSON string to parse.
      # @return [Hash] A symbolized parsed JSON hash.
      def parse(body)
        MultiJson.load(body, symbolize_keys: true)
      rescue MultiJson::ParseError
        body
      end
    end
  end
end
