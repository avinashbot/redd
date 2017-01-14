# frozen_string_literal: true

require_relative 'auth_strategy'

module Redd
  module AuthStrategies
    # For non-confidential apps. Different from the implicit grant.
    class Installed < AuthStrategy
      def initialize(client_id:, redirect_uri:, **kwargs)
        super(client_id: client_id, secret: '', **kwargs)
        @redirect_uri = redirect_uri
      end

      # Authenticate with a code using the "web" flow.
      # @param code [String] the code returned by reddit
      # @return [Access]
      def authenticate(code)
        request_access('authorization_code', code: code, redirect_uri: @redirect_uri)
      end
    end
  end
end
