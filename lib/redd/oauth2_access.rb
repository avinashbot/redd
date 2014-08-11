require "multi_json"

module Redd
  class OAuth2Access
    attr_reader :access_token

    attr_reader :refresh_token

    attr_reader :scope

    attr_reader :duration

    attr_reader :expires_at

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

    def refresh(response)
      @access_token = response[:access_token]
      @expires_at = Time.now + response[:expires_in]
      self
    end

    def expired?
      Time.now > @expires_at
    end

    def to_json
      MultiJson.dump(
        access_token: @access_token,
        refresh_token: @refresh_token,
        scope: @scope.join(","),
        expires_at: @expires_at.to_i
      )
    end

    def self.from_json(json)
      hash = MultiJson.load(json, symbolize_keys: true)
      new(hash)
    end
  end
end