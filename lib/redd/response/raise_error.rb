require "faraday_middleware"
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
            if error == Redd::Error::RateLimited
              time = env.body[:json][:ratelimit]
              fail error.new(env, time)
            else
              fail error.new(env)
            end
          end
        end
      end
    end
  end
end
