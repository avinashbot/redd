# frozen_string_literal: true

require_relative 'auth_strategy'

module Redd
  module AuthStrategies
    # A userless authentication scheme.
    class Userless < AuthStrategy
      # Perform authentication and return the resulting access object
      # @return [Access] the access token object
      def authenticate
        request_access('client_credentials')
      end

      # Refresh the authentication and return the refreshed access
      # @return [Access] the new access
      def refresh(_)
        authenticate
      end
    end
  end
end
