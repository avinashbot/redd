# frozen_string_literal: true

require_relative '../error'

module Redd
  module Utilities
    # Handles response errors in API responses.
    class ErrorHandler
      AUTH_HEADER        = 'www-authenticate'
      INVALID_TOKEN      = 'invalid_token'
      INSUFFICIENT_SCOPE = 'insufficient_scope'

      HTTP_ERRORS = {
        400 => Redd::BadRequest,
        403 => Redd::Forbidden,
        404 => Redd::NotFound,
        500 => Redd::ServerError,
        502 => Redd::ServerError,
        503 => Redd::ServerError,
        504 => Redd::ServerError
      }.freeze

      def check_error(res, raw:)
        # Check for status code-based errors first and return it if we found one.
        error = invalid_access_error(res) || insufficient_scope_error(res) || other_http_error(res)
        return error if error || raw

        # If there wasn't an status code error and we're allowed to look into the response, parse
        # it and check for errors.
        # TODO: deal with errors of type { fields:, explanation:, message:, reason: }
        api_error(res)
      end

      private

      # Deal with an error caused by having an expired or invalid access token.
      def invalid_access_error(res)
        return nil unless res.code == 401 && res.headers[AUTH_HEADER] &&
                          res.headers[AUTH_HEADER].include?(INVALID_TOKEN)
        InvalidAccess.new(res)
      end

      # Deal with an error caused by not having enough the correct scope
      def insufficient_scope_error(res)
        return nil unless res.code == 403 && res.headers[AUTH_HEADER] &&
                          res.headers[AUTH_HEADER].include?(INSUFFICIENT_SCOPE)
        InsufficientScope.new(res)
      end

      # Deal with an error signalled by the HTTP response code.
      def other_http_error(res)
        HTTP_ERRORS[res.code].new(res) if HTTP_ERRORS.key?(res.code)
      end

      # Deal with those annoying errors that come with perfect 200 status codes.
      def api_error(res)
        return nil unless res.body[:json] && res.body[:json][:errors] &&
                          !res.body[:json][:errors].empty?
        APIError.new(res)
      end
    end
  end
end
