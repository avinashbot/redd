# frozen_string_literal: true

require_relative '../error'

module Redd
  module Utilities
    # Handles response errors in API responses.
    # TODO: handle [:json][:errors] array
    class ErrorHandler
      HTTP_ERRORS = {
        400 => Redd::BadRequest,
        404 => Redd::NotFound,
        500 => Redd::ServerError,
        502 => Redd::ServerError,
        503 => Redd::ServerError,
        504 => Redd::ServerError
      }.freeze

      AUTHORIZATION_ERRORS = {
        'insufficient_scope' => Redd::InsufficientScope,
        'invalid_token' => Redd::InvalidAccess
      }.freeze

      def check_error(response)
        return HTTP_ERRORS[response.code].new(response) if HTTP_ERRORS.key?(response.code)
        if response.code == 403
          AUTHORIZATION_ERRORS.each do |key, klass|
            return klass.new(response) if response.headers['www-authenticate'].include?(key)
          end
        end
        nil
      end
    end
  end
end
