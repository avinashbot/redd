module Redd
  # The class that handles rate limiting for reddit. reddit does supply
  # X-Ratelimit headers but only when logged in and using those headers instead
  # would just lead to short bursts, so it's better to go at a constant speed
  # and space out requests every 2 seconds.
  #
  # If you'd rather have short bursts or no rate limiting at all, it's easy to
  # write one yourself. A rate limiting class is any class that has an
  # {#after_limit} method. The block returns a Faraday::Response object, so you
  # can also extract the headers from the response and use those instead. To
  # remove rate limiting entirely, follow the example below.
  #
  # @example No Rate Limiting
  #   class IWantToGetIPBanned
  #     def after_limit
  #       yield
  #     end
  #   end
  #
  #   client = Redd::Unauthenticated.new(rate_limit: IWantToGetIPBanned.new)
  #
  # @note The class itself doesn't perform the rate limiting but only acts
  #   as an updatable container for the values.
  class RateLimit
    # @!attribute [r] last_request_time
    #   @return [String] The time when the last request took place.
    attr_reader :last_request_time

    # @param [Float, Integer] gap The minimum time between each request.
    def initialize(gap = 2)
      # Some time ages ago, because we never made a request.
      @last_request_time = Time.at(0)
      @gap = gap
    end

    # Sleep until 2 seconds have passed since the last request and perform the
    # given request.
    #
    # @yield A block.
    # @return The return value of the block.
    def after_limit
      seconds_passed = Time.now - @last_request_time
      wait_time = @gap - seconds_passed
      sleep(wait_time) if wait_time > 0
      @last_request_time = Time.now
      yield
    end
  end
end
