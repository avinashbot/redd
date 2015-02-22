# The main Redd module.
module Redd
  # The class that handles rate limiting for reddit.
  #
  # If you'd rather have short bursts or no rate limiting at all, it's easy to
  # write one yourself. A rate limiting class is any class that has an
  # {#after_limit} method. The block returns a Faraday::Response object, so you
  # can also extract the headers from the response and use those instead. To
  # remove rate limiting entirely, follow the example below.
  #
  # @note To remove rate limiting entirely, just burst forever.
  #     rt = Redd::RateLimit.new
  #     rt.burst!(Float::INFINITY)
  class RateLimit
    # @!attribute [rw] gap
    # @return [Integer, Float] The minimum time between requests.
    attr_accessor :gap

    # @!attribute [rw] burst_length
    # @return [Integer] The number of requests left to burst.
    attr_accessor :burst_length

    # @!attribute [r] last_request
    # @return [Time] The time the last request was made.
    attr_reader :last_request

    # @!attribute [r] used, remaining, reset
    # @return [Integer] The data from reddit's response headers.
    attr_reader :used, :remaining, :reset

    # @param [Float, Integer] gap The minimum time between each request.
    def initialize(gap)
      # Some time ages ago, because we never made a request.
      @last_request = Time.at(0)
      @gap = gap
      @burst_length = 0
    end

    # Don't sleep for the next few requests.
    # @param [Integer] times The number of times to ignore limiting.
    # @return [Integer] The total times rate limiting will be ignored.
    def burst!(times)
      @burst_length += times
    end

    # Sleep until 1 second has passed since the last request and perform the
    # given request unless bursting.
    #
    # @yield [Faraday::Response] A response.
    # @return [Faraday::Response] The response.
    def after_limit
      response = yield
      update!(response)
      sleep(wait_time)
      response
    end

    private

    # Update necessary info with each request.
    # @param [Faraday::Response] response The response to the request made.
    def update!(response)
      @last_request = Time.now
      %w(used remaining reset).each do |type|
        value = response.headers["x-ratelimit-#{type}"]
        instance_variable_set("@#{type}", value.to_i) unless value.nil?
      end
    end

    # @return [Float, Integer] The number of seconds to sleep.
    def wait_time
      if @burst_length > 0 && @remaining > 0
        # Don't sleep if we are in burst mode.
        @burst_length -= 1
        0
      elsif @reset.nil? || @remaining.nil?
        # Just guess if no headers were given (max 1 sec after last request).
        time = @last_request_time - Time.now + @gap
        time > 0 ? time : 0
      else
        # Most cases, spread out requests over available time.
        @reset.to_f / (@gap * @remaining + 1)
      end
    end
  end
end
