# frozen_string_literal: true

module Redd
  module Utilities
    # Manages rate limiting by sleeping.
    class RateLimiter
      def initialize(gap = 1)
        @gap = 1
        @last_request_time = Time.now - gap
      end

      def after_limit
        sleep_time = (@last_request_time + @gap) - Time.now
        sleep(sleep_time) if sleep_time > 0.01
        response = yield
        @last_request_time += @gap
        response
      end
    end
  end
end
