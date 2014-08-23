module Redd
  # An error from reddit
  class Error < StandardError
    attr_reader :code
    attr_reader :headers
    attr_reader :body

    def initialize(env)
      @code = env.status
      @headers = env.response_headers
      @body = env.body
    end

    class << self
      # rubocop:disable Style/CyclomaticComplexity, Style/MethodLength
      def from_response(response)
        status = response[:status]
        body = parse_error(response[:body]).to_s
        case status
        when 200
          case body
          when /ACCESS_DENIED/i
            Redd::Error::OAuth2AccessDenied
          when /UNSUPPORTED_RESPONSE_TYPE/i
            Redd::Error::InvalidResponseType
          when /UNSUPPORTED_GRANT_TYPE/i
            Redd::Error::InvalidGrantType
          when /INVALID_SCOPE/i
            Redd::Error::InvalidScope
          when /INVALID_REQUEST/i
            Redd::Error::InvalidRequest
          when /NO_TEXT/i
            Redd::Error::NoTokenGiven
          when /INVALID_GRANT/i
            Redd::Error::ExpiredCode
          when /WRONG_PASSWORD/i
            Redd::Error::InvalidCredentials
          when /BAD_CAPTCHA/i
            Redd::Error::InvalidCaptcha
          when /RATELIMIT/i
            Redd::Error::RateLimited
          when /BAD_CSS_NAME/i
            Redd::Error::InvalidClassName
          when /TOO_OLD/i
            Redd::Error::Archived
          when /TOO_MUCH_FLAIR_CSS/i
            Redd::Error::TooManyClassNames
          when /USER_REQUIRED/i
            Redd::Error::AuthenticationRequired
          end
        when 400
          Redd::Error::BadRequest
        when 401
          Redd::Error::InvalidOAuth2Credentials
        when 403
          case body
          when /USER_REQUIRED/i
            Redd::Error::AuthenticationRequired
          else
            Redd::Error::PermissionDenied
          end
        when 404
          Redd::Error::NotFound
        when 409
          Redd::Error::Conflict
        when 500
          Redd::Error::InternalServerError
        when 502
          Redd::Error::BadGateway
        when 503
          Redd::Error::ServiceUnavailable
        when 504
          Redd::Error::TimedOut
        end
      end
      # rubocop:enable Style/CyclomaticComplexity, Style/MethodLength

      def parse_error(body)
        return nil unless body.is_a?(Hash)

        if body.key?(:json) && body[:json].key?(:errors)
          body[:json][:errors].first
        elsif body.key?(:jquery)
          body[:jquery]
        elsif body.key?(:error)
          body[:error]
        elsif body.key?(:code) && body[:code] == "NO_TEXT"
          "NO_TEXT"
        end
      end
    end
  end

  class NoTokenGiven < Error; end

  class ExpiredCode < Error; end

  class InvalidGrantType < Error; end

  class InvalidOAuth2Credentials < Error; end

  class OAuth2AccessDenied < Error; end

  class InvalidResponseType < Error; end

  class InvalidScope < Error; end

  class InvalidRequest < Error; end

  class AuthenticationRequired < Error; end

  class InvalidCaptcha < Error; end

  class BadGateway < Error; end

  class BadRequest < Error; end

  class InvalidMultiredditName < Error; end

  class Conflict < Error; end

  class InternalServerError < Error; end

  class InvalidClassName < Error; end

  class InvalidCredentials < Error; end

  class NotFound < Error; end

  class PermissionDenied < Error; end

  # Raised when the client needs to wait before making another request
  class RateLimited < Error
    attr_reader :time

    def initialize(env, time)
      @code = env.status
      @headers = env.response_headers
      @body = env.body
      @time = time
    end
  end

  class RequestError < Error; end

  class ServiceUnavailable < Error; end

  class TooManyClassNames < Error; end

  class Archived < Error; end

  class TimedOut < Error; end
end
end
