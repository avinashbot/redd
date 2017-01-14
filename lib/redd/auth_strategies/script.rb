# frozen_string_literal: true

require_relative 'auth_strategy'

module Redd
  module AuthStrategies
    # A password-based authentication scheme. Requests all scopes.
    class Script < AuthStrategy
      def initialize(client_id:, secret:, username:, password:, **kwargs)
        super(client_id: client_id, secret: secret, **kwargs)
        @username = username
        @password = password
      end

      # Perform authentication and return the resulting access object
      # @return [Access] the access token object
      def authenticate
        request_access('password', username: @username, password: @password)
      end
      alias refresh authenticate
    end
  end
end
