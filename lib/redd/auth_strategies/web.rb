# frozen_string_literal: true

require_relative 'auth_strategy'

module Redd
  module AuthStrategies
    # A typical code-based authentication, for 'web' and 'installed' types.
    class Web < AuthStrategy
      def initialize(client_id:, redirect_uri:, secret: '', **kwargs)
        super(client_id: client_id, secret: secret, **kwargs)
        @redirect_uri = redirect_uri
      end

      # Authenticate with a code using the "web" flow.
      # @param code [String] the code returned by reddit
      # @return [Access]
      def authenticate(code)
        request_access('authorization_code', code: code, redirect_uri: @redirect_uri)
      end

      # @return [Boolean] whether the access has a refresh token
      def refreshable?(access)
        access.permanent?
      end

      # Refresh the authentication and return a new refreshed access
      # @return [Access] the new access
      def refresh(access)
        token = access.is_a?(String) ? access : access.refresh_token
        response = post('/api/v1/access_token', grant_type: 'refresh_token', refresh_token: token)
        # When refreshed, the response doesn't include an access token, so we have to add it.
        Models::Access.new(response.body.merge(refresh_token: token))
      end
    end
  end
end
