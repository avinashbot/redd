module Redd
  # An error from reddit
  class Error < StandardError
    attr_reader :code
    attr_reader :headers
    attr_reader :body

    def initialize(env)
      @code = env[:status]
      @headers = env[:response_headers]
      @body = env[:body]
    end

    def self.from_response(env) # rubocop:disable all
      status = env[:status]
      body = parse_error(env[:body]).to_s
      case status
      when 200
        case body
        when /access_denied/i             then OAuth2AccessDenied
        when /unsupported_response_type/i then InvalidResponseType
        when /unsupported_grant_type/i    then InvalidGrantType
        when /invalid_scope/i             then InvalidScope
        when /invalid_request/i           then InvalidRequest
        when /no_text/i                   then NoTokenGiven
        when /invalid_grant/i             then ExpiredCode
        when /wrong_password/i            then InvalidCredentials
        when /bad_captcha/i               then InvalidCaptcha
        when /ratelimit/i                 then RateLimited
        when /quota_filled/i              then RateLimited
        when /bad_css_name/i              then InvalidClassName
        when /too_old/i                   then Archived
        when /too_much_flair_css/i        then TooManyClassNames
        when /user_required/i             then AuthenticationRequired
        end
      when 400 then BadRequest
      when 401 then InvalidOAuth2Credentials
      when 403
        if /user_required/i =~ body
          AuthenticationRequired
        else
          PermissionDenied
        end
      when 404 then NotFound
      when 409 then Conflict
      when 500 then InternalServerError
      when 502 then BadGateway
      when 503 then ServiceUnavailable
      when 504 then TimedOut
      end
    end

    def self.parse_error(body) # rubocop:disable all
      return body unless body.is_a?(Hash)

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

    # This item has been archived and can no longer be edited.
    Archived = Class.new(Error)

    AuthenticationRequired = Class.new(Error)

    # Bad Gateway. Either a network or a reddit error. Either way, try again.
    BadGateway = Class.new(Error)

    BadRequest = Class.new(Error)

    Conflict = Class.new(Error)

    # You already received an access token using this code. The user should
    # grant you access again to get a new code.
    ExpiredCode = Class.new(Error)

    # There is an issue on reddit's end. Try again.
    InternalServerError = Class.new(Error)

    InvalidCaptcha = Class.new(Error)

    InvalidClassName = Class.new(Error)

    # Either your username or your password is wrong.
    InvalidCredentials = Class.new(Error)

    InvalidGrantType = Class.new(Error)

    InvalidMultiredditName = Class.new(Error)

    # Your client id or your secret is wrong.
    InvalidOAuth2Credentials = Class.new(Error)

    InvalidResponseType = Class.new(Error)

    InvalidRequest = Class.new(Error)

    # You don't have the proper scope to perform this request.
    InvalidScope = Class.new(Error)

    # Four, oh four! The thing you're looking for wasn't found.
    NotFound = Class.new(Error)

    # No access token was given.
    NoTokenGiven = Class.new(Error)

    OAuth2AccessDenied = Class.new(Error)

    PermissionDenied = Class.new(Error)

    # Raised when the client needs to wait before making another request
    class RateLimited < Error
      # @!attribute [r] time
      # @return [Integer] the seconds to wait before making another request.
      attr_reader :time

      def initialize(env)
        @time = env[:body][:json][:ratelimit] || 60*60
        super
      end
    end

    RequestError = Class.new(Error)

    # Issue on reddit's end. Try again.
    ServiceUnavailable = Class.new(Error)

    # The connection timed out. Try again.
    TimedOut = Class.new(Error)

    TooManyClassNames = Class.new(Error)
  end
end
