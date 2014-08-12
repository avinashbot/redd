require "multi_json"

module Redd
  # A container for the client's access to their account via OAuth2
  class OAuth2Access
    # @!attribute [r] access_token
    #   @return [String] The access token used to access the users account.
    attr_reader :access_token

    # @!attribute [r] refresh_token
    #   @return [String, nil] The refresh token, if the access was permanent.
    attr_reader :refresh_token

    # @!attribute [r] scope
    #   @return [Array] The scope that the client is allowed to access.
    attr_reader :scope

    # @!attribute [r] duration
    #   @return [Symbol] Time the client is given access (temporary/permanent)
    attr_reader :duration

    # @!attribute [r] expires_at
    #   @return [Time] The time when the access token expires.
    attr_reader :expires_at

    # @param response [String] The response body containing the required info.
    def initialize(response)
      @access_token = response[:access_token]
      @refresh_token = response[:refresh_token]
      @scope = response[:scope].split(",").map { |s| s.to_sym }
      @duration = @refresh_token ? :permanent : :temporary
      @expires_at =
        if response[:expires_at]
          Time.at(response[:expires_at])
        else
          Time.now + response[:expires_in]
        end
    end

    # Refresh the object with the new response.
    # This happens when a new access token is requested using a request token.
    def refresh(response)
      @access_token = response[:access_token]
      @expires_at = Time.now + response[:expires_in]
    end

    # @return [Boolean] Whether the access has expired.
    def expired?
      Time.now > @expires_at
    end

    # @return [String] A JSON representation of the data that can be loaded later.
    def to_json
      MultiJson.dump(
        access_token: @access_token,
        refresh_token: @refresh_token,
        scope: @scope.join(","),
        expires_at: @expires_at.to_i
      )
    end

    # Create a new instance of the class from the JSON returned from #to_json
    # @return [OAuth2Access]
    def self.from_json(json)
      hash = MultiJson.load(json, symbolize_keys: true)
      new(hash)
    end
  end
end
