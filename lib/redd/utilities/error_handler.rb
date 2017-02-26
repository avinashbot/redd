# frozen_string_literal: true

require_relative '../error'

module Redd
  module Utilities
    # Handles response errors in API responses.
    class ErrorHandler
      HTTP_ERRORS = {
        400 => Redd::BadRequest,
        403 => Redd::Forbidden,
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

      def check_error(response, raw:)
        # TODO: deal with errors of type { fields:, explanation:, message:, reason: }
        if !raw && response.body.is_a?(Hash) && response.body[:json] &&
           response.body[:json][:errors] && !response.body[:json][:errors].empty?
          Redd::APIError.new(response)
        elsif HTTP_ERRORS.key?(response.code)
          HTTP_ERRORS[response.code].new(response)
        elsif response.code == 401
          AUTHORIZATION_ERRORS.each do |key, klass|
            auth_header = response.headers['www-authenticate']
            return klass.new(response) if auth_header && auth_header.include?(key)
          end
        end
      end
    end
  end
end
