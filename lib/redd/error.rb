# frozen_string_literal: true

module Redd
  # An error raised by {Redd::Middleware} when there was an error returned by reddit.
  class TokenRetrievalError < StandardError; end

  # An error with the API.
  class APIError < StandardError
    attr_reader :response, :name

    def initialize(response)
      @response = response
      @name, message = response.body[:json][:errors][0]
      super(message)
    end
  end

  # Represents an error from reddit returned in a response.
  class ResponseError < StandardError
    attr_accessor :response

    def initialize(response)
      super(response.raw_body.length <= 80 ? response.raw_body : "#{response.raw_body[0..80]}...")
      @response = response
    end
  end

  # An error returned by AuthStrategy.
  # @note A common cause of this error is not having a bot account registered as a developer on
  #   the app.
  class AuthenticationError < ResponseError; end

  # An error with Redd, probably (let me know!)
  class BadRequest < ResponseError; end

  # Whatever it is, you're not allowed to do it.
  class Forbidden < ResponseError; end

  # You don't have the correct scope to do this.
  class InsufficientScope < ResponseError; end

  # The access object supplied was invalid.
  class InvalidAccess < ResponseError; end

  # Returned when reddit raises a 404 error.
  class NotFound < ResponseError; end

  # Too many requests and not enough rate limiting.
  class TooManyRequests < ResponseError; end

  # An unknown error on reddit's end. Usually fixed with a retry.
  class ServerError < ResponseError; end
end
