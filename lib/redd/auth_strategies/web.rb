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

      # Refresh the authentication and return a new refreshed access
      # @return [Access] the new access
      def refresh(access)
        refresh_token = access.is_a?(String) ? refresh_token : access.refresh_token
        request_access('refresh_token', refresh_token: refresh_token)
      end
    end
  end
end
