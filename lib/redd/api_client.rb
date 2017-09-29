# frozen_string_literal: true

require_relative 'client'
require_relative 'utilities/error_handler'
require_relative 'utilities/rate_limiter'
require_relative 'utilities/unmarshaller'

module Redd
  # The class for API clients.
  class APIClient < Client
    # The endpoint to make API requests to.
    API_ENDPOINT = 'https://oauth.reddit.com'

    # @return [APIClient] the access the client uses
    attr_accessor :access

    # Create a new API client with an auth strategy.
    # @param auth [AuthStrategies::AuthStrategy] the auth strategy to use
    # @param endpoint [String] the API endpoint
    # @param user_agent [String] the user agent to send
    # @param limit_time [Integer] the minimum number of seconds between each request
    # @param max_retries [Integer] number of times to retry requests that may succeed if retried
    # @param auto_refresh [Boolean] automatically refresh access token if nearing expiration
    def initialize(auth, endpoint: API_ENDPOINT, user_agent: USER_AGENT, limit_time: 1,
                   max_retries: 5, auto_refresh: true)
      super(endpoint: endpoint, user_agent: user_agent)

      @auth          = auth
      @access        = nil
      @max_retries   = max_retries
      @failures      = 0
      @error_handler = Utilities::ErrorHandler.new
      @rate_limiter  = Utilities::RateLimiter.new(limit_time)
      @unmarshaller  = Utilities::Unmarshaller.new(self)
      @auto_refresh  = auto_refresh
    end

    # Authenticate the client using the provided auth.
    def authenticate(*args)
      @access = @auth.authenticate(*args)
    end

    # Refresh the access currently in use.
    def refresh
      @access = @auth.refresh(@access)
    end

    # Revoke the current access and remove it from the client.
    def revoke
      @auth.revoke(@access)
      @access = nil
    end

    def unmarshal(object)
      @unmarshaller.unmarshal(object)
    end

    def model(verb, path, options = {})
      # XXX: make unmarshal explicit in methods?
      unmarshal(send(verb, path, options).body)
    end

    # Makes a request, ensuring not to break the rate limit by sleeping.
    # @see Client#request
    def request(verb, path, raw: false, params: {}, **options)
      # Make sure @access is populated by a valid access
      ensure_access_is_valid
      # Setup base API params and make request
      api_params = { api_type: 'json', raw_json: 1 }.merge(params)

      # This loop is retried @max_retries number of times until it succeeds
      handle_retryable_errors do
        response = @rate_limiter.after_limit { super(verb, path, params: api_params, **options) }
        # Raise errors if encountered at the API level.
        response_error = @error_handler.check_error(response, raw: raw)
        raise response_error unless response_error.nil?
        # All done, return the response
        response
      end
    end

    private

    # Makes sure a valid access is present, raising an error if nil
    def ensure_access_is_valid
      # If access is nil, panic
      raise 'client access is nil, try calling #authenticate' if @access.nil?
      # Refresh access if auto_refresh is enabled
      refresh if @access.expired? && @auto_refresh && @auth && @auth.refreshable?(@access)
    end

    def handle_retryable_errors
      response = yield
    rescue Errors::ServerError, HTTP::TimeoutError => e
      # FIXME: maybe only retry GET requests, for obvious reasons?
      @failures += 1
      raise e if @failures > @max_retries
      warn "Redd got a #{e.class.name} error (#{e.message}), retrying..."
      retry
    else
      @failures = 0
      response
    end

    def connection
      super.auth("Bearer #{@access.access_token}")
    end
  end
end
