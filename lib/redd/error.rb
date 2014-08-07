module Redd
  class Error < StandardError
    class << self
      # @note I ripped off RedditKit.rb :|
      def from_response(response) # rubocop:disable Style/CyclomaticComplexity Style/MethodLength
        status = response[:status]
        body = parse_error(response[:body]).to_s
        case status
        when 200
          case body
          when /WRONG_PASSWORD/i
            InvalidCredentials
          when /BAD_CAPTCHA/i
            InvalidCaptcha
          when /RATELIMIT/i
            RateLimited
          when /BAD_CSS_NAME/i
            InvalidClassName
          when /TOO_OLD/i
            Archived
          when /TOO_MUCH_FLAIR_CSS/i
            TooManyClassNames
          when /USER_REQUIRED/i
            AuthenticationRequired
          end
        when 400
          BadRequest
        when 403
          case body
          when /USER_REQUIRED/i
            AuthenticationRequired
          else
            PermissionDenied
          end
        when 404
          NotFound
        when 409
          Conflict
        when 500
          InternalServerError
        when 502
          BadGateway
        when 503
          ServiceUnavailable
        when 504
          TimedOut
        end
      end

      def parse_error(body)
        return nil unless body.is_a?(Hash)

        if body.key?(:json) && body[:json].key?(:errors)
          body[:json][:errors].first
        elsif body.key?(:jquery)
          body[:jquery]
        end
      end
    end

    class AuthenticationRequired < Error; end

    class InvalidCaptcha < Error; end

    class BadGateway < Error; end

    class InvalidMultiredditName < Error; end

    class Conflict < Error; end

    class InternalServerError < Error; end

    class InvalidClassName < Error; end

    class InvalidCredentials < Error; end

    class NotFound < Error; end

    class PermissionDenied < Error; end

    class RateLimited < Error
      attr_reader :time
      def initialize(time = 0)
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
