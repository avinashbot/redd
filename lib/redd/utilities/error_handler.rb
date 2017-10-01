# frozen_string_literal: true

require_relative '../errors'

module Redd
  module Utilities
    # Handles response errors in API responses.
    class ErrorHandler
      AUTH_HEADER        = 'www-authenticate'
      INVALID_TOKEN      = 'invalid_token'
      INSUFFICIENT_SCOPE = 'insufficient_scope'

      HTTP_ERRORS = {
        400 => Errors::BadRequest,
        403 => Errors::Forbidden,
        404 => Errors::NotFound,
        429 => Errors::TooManyRequests,
        500 => Errors::ServerError,
        502 => Errors::ServerError,
        503 => Errors::ServerError,
        504 => Errors::ServerError
      }

      def check_error(res, raw:)
        # Check for status code-based errors first and return it if we found one.
        error = invalid_access_error(res) || insufficient_scope_error(res) || other_http_error(res)
        return error if error || raw

        # If there wasn't an status code error and we're allowed to look into the response, parse
        # it and check for errors.
        # TODO: deal with errors of type { fields:, explanation:, message:, reason: }
        rate_limit_error(res) || other_api_error(res)
      end

      private

      # Deal with an error caused by having an expired or invalid access token.
      def invalid_access_error(res)
        return nil unless res.code == 401 && res.headers[AUTH_HEADER] &&
                          res.headers[AUTH_HEADER].include?(INVALID_TOKEN)
        Errors::InvalidAccess.new(res)
      end

      # Deal with an error caused by not having enough the correct scope
      def insufficient_scope_error(res)
        return nil unless res.code == 403 && res.headers[AUTH_HEADER] &&
                          res.headers[AUTH_HEADER].include?(INSUFFICIENT_SCOPE)
        Errors::InsufficientScope.new(res)
      end

      # Deal with an error signalled by the HTTP response code.
      def other_http_error(res)
        HTTP_ERRORS[res.code].new(res) if HTTP_ERRORS.key?(res.code)
      end

      def rate_limit_error(res)
        # {"json": {"ratelimit": 487.423861, "errors": [["RATELIMIT", "you are doing that too much. try again in 8 minutes.", "ratelimit"]]}}
        return nil unless res.body.is_a?(Hash) && res.body[:json] && res.body[:json][:ratelimit]
        Errors::RateLimitError.new(res)
      end

      # Deal with those annoying errors that come with perfect 200 status codes.
      def other_api_error(res)
        return nil unless res.body.is_a?(Hash) && res.body[:json] && res.body[:json][:errors] &&
                          !res.body[:json][:errors].empty?
        Errors::APIError.new(res)
      end
    end
  end
end
