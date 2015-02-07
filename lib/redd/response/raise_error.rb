require "faraday/response"
require_relative "../error"

module Redd
  # The module that contains middleware that alters the Faraday response.
  module Response
    # Faraday Middleware that raises an error if there's one.
    # @see Error
    class RaiseError < Faraday::Response::Middleware
      def on_complete(env)
        error = Redd::Error.from_response(env)
        fail error.new(env), env[:body] if error
      end
    end
  end
end
