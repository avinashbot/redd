require "multi_json"

module Redd
  # A container for the client's access to their account via OAuth2
  class Access
    # @!attribute [r] access_token
    #   @return [String] The access token used to access the users account.
    attr_reader :access_token

    # @!attribute [r] refresh_token
    #   @return [String, nil] The refresh token, if the access was permanent.
    attr_reader :refresh_token

    # @!attribute [r] scope
    #   @return [Array] The scope that the client is allowed to access.
    attr_reader :scope

    # @!attribute [r] expires_at
    #   @return [Time] The time when the access token expires.
    attr_reader :expires_at

    # @param [String] body The response body containing the required info.
    def initialize(body)
      @access_token = body[:access_token]
      @refresh_token = body[:refresh_token]
      @scope = (body[:scope] ? body[:scope].split(",") : [])
      @expires_at =
        if body[:expires_at]
          Time.at(body[:expires_at])
        else
          Time.now + (body[:expires_in] || 0)
        end
    end

    # @return [Boolean] Whether the access is temporary.
    def temporary?
      !refresh_token
    end

    # @return [Boolean] Whether the access is permanent.
    def permanent?
      !temporary?
    end

    # @return [Boolean] Whether the access has expired.
    def expired?
      Time.now > @expires_at
    end

    # Refresh the object with the new response body.
    # This happens when a new access token is requested using a request token.
    # @param [Hash] body The new response body.
    def refreshed!(body)
      @access_token = body[:access_token]
      @expires_at = Time.now + body[:expires_in]
    end

    # @return [String] A JSON version of the data that can be loaded later.
    def to_json
      MultiJson.dump(
        access_token: @access_token,
        refresh_token: @refresh_token,
        scope: @scope.join(","),
        expires_at: @expires_at.to_i
      )
    end

    # Create a new instance of the class from the JSON returned from #to_json
    # @param [String] json
    # @return [OAuth2Access]
    def self.from_json(json)
      hash = MultiJson.load(json, symbolize_keys: true)
      new(hash)
    end
  end
end
