# frozen_string_literal: true

module Redd
  # Represents an error from reddit returned in a response.
  class ResponseError < StandardError
    attr_accessor :response

    def initialize(response)
      super(response.raw_body.length <= 80 ? response.raw_body : "#{response.raw_body[0..80]}...")
      @response = response
    end
  end

  # An error with Redd, probably (let me know!)
  class BadRequest < ResponseError; end

  # You don't have the correct scope to do this.
  class InsufficientScope < ResponseError; end

  # The access object supplied was invalid.
  class InvalidAccess < ResponseError; end

  # Returned when reddit raises a 404 error.
  class NotFound < ResponseError; end

  # An unknown error on reddit's end. Usually fixed with a retry.
  class ServerError < ResponseError; end
end
