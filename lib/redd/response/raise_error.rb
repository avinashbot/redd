require "redd/error"

module Redd
  module Response
    # Raises the appropriate error when one comes up.
    class RaiseError < Faraday::Middleware
      # Call the middleware.
      # @param faraday
      def call(faraday)
        @app.call(faraday).on_complete do |env|
          error = Redd::Error.from_response(env)
          if error
            info = Redd::Error.parse_error(env[:body])
            fail error, info
          end
        end
      end
    end
  end
end
